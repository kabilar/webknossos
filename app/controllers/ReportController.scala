/*
 * Copyright (C) 2011-2017 scalable minds UG (haftungsbeschränkt) & Co. KG. <http://scm.io>
 */
package controllers

import javax.inject.Inject

import com.scalableminds.util.reactivemongo.{DBAccessContext, GlobalAccessContext}
import com.scalableminds.util.tools.{Fox, FoxImplicits}
import models.annotation.{AnnotationDAO, AnnotationType}
import models.project.{Project, ProjectDAO}
import models.task._
import models.team.TeamDAO
import models.user.{Experience, User, UserDAO}
import oxalis.security.WebknossosSilhouette.SecuredAction
import play.api.i18n.MessagesApi
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.json.Json
import reactivemongo.bson.BSONObjectID

import scala.concurrent.duration._


case class OpenTasksEntry(id: String, user: String, totalAssignments: Int, assignmentsByProjects: Map[String, Int])
object OpenTasksEntry { implicit val jsonFormat = Json.format[OpenTasksEntry] }

case class ProjectProgressEntry(projectName: String, paused: Boolean, totalTasks: Int, totalInstances: Int, openInstances: Int,
                                finishedInstances: Int, activeInstances: Int)
object ProjectProgressEntry { implicit val jsonFormat = Json.format[ProjectProgressEntry] }

class ReportController @Inject()(val messagesApi: MessagesApi) extends Controller with FoxImplicits {

  def projectProgressOverview(teamId: String) = SecuredAction.async { implicit request =>
    for {
      team <- TeamDAO.findOneById(teamId)(GlobalAccessContext) ?~> "team.notFound"
      teamWithParent = List(Some(team.name), team.parent).flatten
      users <- UserDAO.findByTeams(teamWithParent, false)
      projects <- ProjectDAO.findAllByTeamNames(teamWithParent)(GlobalAccessContext)
      entryBoxes <- Fox.sequence(projects.map(p => progressOfProject(p, users)(GlobalAccessContext)))
    } yield {
      Ok(Json.toJson(entryBoxes.flatten))
    }
  }

  private def progressOfProject(project: Project, users: List[User])(implicit ctx: DBAccessContext): Fox[ProjectProgressEntry] = {
    for {
      taskIds <- TaskDAO.findAllByProjectReturnOnlyIds(project.name)
      totalTasks = taskIds.length
      firstTask <- TaskDAO.findOneByProject(project.name)
      totalInstances <- TaskDAO.sumInstancesByProject(project.name)
      finishedInstances <- AnnotationDAO.countFinishedByTaskIdsAndType(taskIds, AnnotationType.Task)
      activeInstances <- AnnotationDAO.countActiveByTaskIdsAndType(taskIds, AnnotationType.Task)
      openInstances = totalInstances - finishedInstances - activeInstances
      _ <- assertNotPaused(project, finishedInstances, activeInstances)
      _ <- assertExpDomain(firstTask, activeInstances, users)
      _ <- assertAge(project, taskIds, activeInstances, openInstances)
    } yield {
      ProjectProgressEntry(project.name, project.paused, totalTasks, totalInstances, openInstances, finishedInstances, activeInstances)
    }
  }

  private def assertNotPaused(project: Project, finishedInstances: Int, activeInstances: Int) = {
    if (project.paused && finishedInstances == 0 && activeInstances == 0) {
      Fox.failure("")
    } else Fox.successful(())
  }

  private def assertExpDomain(firstTask: Task, activeInstances: Int, users: List[User])(implicit ctx: DBAccessContext) = {
    if (activeInstances > 0) Fox.successful(())
    else assertMatchesAnyUserOfTeam(firstTask.neededExperience, users)
  }

  private def assertMatchesAnyUserOfTeam(experience: Experience, users: List[User])(implicit ctx: DBAccessContext) = {
    for {
      _ <- users.exists(user => user.experiences.contains(experience.domain) && user.experiences(experience.domain) >= experience.value)
    } yield {
      ()
    }
  }

  private def assertAge(project: Project, taskIds: List[BSONObjectID], activeInstances: Int, openInstances: Int)(implicit ctx: DBAccessContext) = {
    if (activeInstances > 0 || (!project.paused && openInstances > 0)) Fox.successful(())
    else {
      assertRecentlyModified(taskIds)
    }
  }

  private def assertRecentlyModified(taskIds: List[BSONObjectID])(implicit ctx: DBAccessContext) = {
    for {
      count <- AnnotationDAO.countRecentlyModifiedByTaskIdsAndType(taskIds, AnnotationType.Task, System.currentTimeMillis - (30 days).toMillis)
      _ <- count > 0
    } yield {
      ()
    }
  }


  /**
    * assumes that all tasks of a project have the same required experience
    */
  def openTasksOverview(id: String) = SecuredAction.async { implicit request =>
    for {
      team <- TeamDAO.findOneById(id)(GlobalAccessContext)
      users <- UserDAO.findByTeams(List(team.name), includeAnonymous = true, includeInactive = false)(GlobalAccessContext)
      nonAdminUsers = users.filterNot(_.isAdminOf(team.name))
      entries: List[OpenTasksEntry] <- getAllAvailableTaskCountsAndProjects(nonAdminUsers)(GlobalAccessContext)
    } yield {
      Ok(Json.toJson(entries))
    }
  }


  private def getAllAvailableTaskCountsAndProjects(users: Seq[User])(implicit ctx: DBAccessContext): Fox[List[OpenTasksEntry]] = {
    val foxes = users.map { user =>
      for {
        projects <- TaskDAO.findWithOpenByUserReturnOnlyProject(user).toFox
        assignmentCountsByProject <- getAssignmentsByProjectsFor(projects, user)
      } yield {
        OpenTasksEntry(user.id, user.name, assignmentCountsByProject.values.sum, assignmentCountsByProject)
      }
    }
    Fox.combined(foxes.toList)
  }

  private def getAssignmentsByProjectsFor(projects: Seq[String], user: User)(implicit ctx: DBAccessContext): Fox[Map[String, Int]] = {
    val projectsGrouped = projects.groupBy(identity).mapValues(_.size)
    val foxes: Iterable[Fox[(String, Int)]] = projectsGrouped.keys.map {
      project =>
        Fox(for {
          tasksIds <- TaskDAO.findAllByProjectReturnOnlyIds(project)
          doneTasks <- AnnotationDAO.countFinishedByTaskIdsAndUserIdAndType(tasksIds, user._id, AnnotationType.Task)
          firstTask <- TaskDAO.findOneByProject(project)
        } yield {
          (project + "/" + firstTask.neededExperience.toString, projectsGrouped(project) - doneTasks)
        })
    }
    for {
      list <- Fox.combined(foxes.toList)
    } yield {
      list.toMap.filter(_ match { case (title: String, openTaskCount: Int) => openTaskCount > 0 })
    }
  }

}