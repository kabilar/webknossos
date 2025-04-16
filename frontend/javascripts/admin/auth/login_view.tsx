import { Card, Col, Row } from "antd";
import * as Utils from "libs/utils";
import window from "libs/window";
import type { RouteComponentProps } from "react-router-dom";
import { withRouter } from "react-router-dom";
import LoginForm from "./login_form";

type Props = {
  history: RouteComponentProps["history"];
  redirect?: string;
};

function LoginView({ history, redirect }: Props) {
  const onLoggedIn = () => {
    if (!Utils.hasUrlParam("redirectPage")) {
      if (redirect) {
        // Use "redirect" prop for internal redirects, e.g. for SecuredRoutes
        history.push(redirect);
      } else {
        history.push("/dashboard");
      }
    } else {
      // Use "redirectPage" URL parameter to cause a full page reload and redirecting to external sites
      // e.g. Discuss
      window.location.replace(Utils.getUrlParamValue("redirectPage"));
    }
  };

  return (
    <Row justify="center" align="middle" className="login-view">
      <Col xs={22} sm={20} md={16} lg={12} xl={8}>
        <Card className="login-content" style={{ margin: "0 auto" }}>
          <h3>Login</h3>
          <h5>WebKNOSSOS for <a href="https://connects.mgh.harvard.edu/">LINC</a> is accessible only to approved users
          </h5>
          <br></br>
          <h5>Webknossos can be accessed by selecting the Webknossos links on the <a href="https://lincbrain.org">LINC
            Data Platform</a> homepage
            or in the file browser next to each asset</h5>
          <br></br>
          <h5>Please ensure that you are <b>not using an Incognito browser session</b> as cookies are required for login
            via the LINC Data Platform
          </h5>
          {/*<LoginForm layout="horizontal" onLoggedIn={onLoggedIn} />*/}
        </Card>
      </Col>
    </Row>
  );
}

export default withRouter<RouteComponentProps & Props, any>(LoginView);
