import _ from "lodash";
import type { Vector3, Vector4 } from "oxalis/constants";
import type { ElementClass } from "types/api_flow_types";
import type { ShaderModule } from "./shader_module_system";

export const hsvToRgb: ShaderModule = {
  requirements: [],
  code: `
    /* Inspired from: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl */
    vec3 hsvToRgb(vec4 HSV)
    {
      vec4 K;
      vec3 p;
      K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
      p = abs(fract(HSV.xxx + K.xyz) * 6.0 - K.www);
      return HSV.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), HSV.y);
    }

    /* https://gist.github.com/983/e170a24ae8eba2cd174f */
    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }
  `,
};

// From: https://stackoverflow.com/a/54024653
// input: h in [0,360] and s,v in [0,1] - output: r,g,b in [0,1]
export function jsHsv2rgb(h: number, s: number, v: number): Vector3 {
  const f = (n: number, k = (n + h / 60) % 6) => v - v * s * Math.max(Math.min(k, 4 - k, 1), 0);
  return [f(5), f(3), f(1)];
}

// From: https://stackoverflow.com/a/54070620/896760
// Input: r,g,b in [0,1], out: h in [0,360) and s,v in [0,1]
export function jsRgb2hsv(rgb: Vector3): Vector3 {
  const [r, g, b] = rgb;
  const v = Math.max(r, g, b);
  const n = v - Math.min(r, g, b);

  const h = n !== 0 && (v === r ? (g - b) / n : v === g ? 2 + (b - r) / n : 4 + (r - g) / n);
  // @ts-expect-error ts-migrate(2365) FIXME: Operator '+' cannot be applied to types 'number | ... Remove this comment to see the full error message
  return [60 * (h < 0 ? h + 6 : h), v && n / v, v];
}

/**
 * Adapted from https://stackoverflow.com/a/9493060.
 *
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 1] and
 * returns h, s, and l in the set [0, 1].
 */
export function jsRgb2hsl(rgb: Vector3): Vector3 {
  const [r, g, b] = rgb;
  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  let h;
  let s;
  const l = (max + min) / 2;

  if (max === min) {
    // achromatic
    h = 0;
    s = 0;
  } else {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r: {
        h = (g - b) / d + (g < b ? 6 : 0);
        break;
      }
      case g: {
        h = (b - r) / d + 2;
        break;
      }
      case b:
      default:
        h = (r - g) / d + 4;
        break;
    }
    h /= 6;
  }

  return [h, s, l];
}

export const colormapJet: ShaderModule = {
  requirements: [],
  code: `
    vec3 colormapJet(float x) {
      vec3 result;
      result.r = x < 0.89 ? ((x - 0.35) / 0.31) : (1.0 - (x - 0.89) / 0.11 * 0.5);
      result.g = x < 0.64 ? ((x - 0.125) * 4.0) : (1.0 - (x - 0.64) / 0.27);
      result.b = x < 0.34 ? (0.5 + x * 0.5 / 0.11) : (1.0 - (x - 0.34) / 0.31);
      return clamp(result, 0.0, 1.0);
    }
  `,
};
// Input in [0,1]
// Output in [0,1] for r, g and b
export function jsColormapJet(x: number): Vector3 {
  const r = _.clamp(x < 0.89 ? (x - 0.35) / 0.31 : 1.0 - ((x - 0.89) / 0.11) * 0.5, 0, 1);

  const g = _.clamp(x < 0.64 ? (x - 0.125) * 4.0 : 1.0 - (x - 0.64) / 0.27, 0, 1);

  const b = _.clamp(x < 0.34 ? 0.5 + (x * 0.5) / 0.11 : 1.0 - (x - 0.34) / 0.31, 0, 1);

  return [r, g, b];
}

export const rgbaToCSS = (rgba: Vector4) => {
  const [r, g, b, a] = rgba;
  return `rgba(${255 * r}, ${255 * g}, ${255 * b}, ${a})`;
};

export const aaStep: ShaderModule = {
  requirements: [],
  code: `
    /*
      Antialiased step function.
      Parameter x must not be discontinuous

      See: https://www.shadertoy.com/view/wtjGzt
    */
    float aaStep(float x) {
      // float w = fwidth(x);    // pixel width
      // inspired by https://www.shadertoy.com/view/MlByRD
      float w = pow(2., zoomValue)/viewportExtent.x;

      return smoothstep(.7, -.7, (abs(fract(x - .25) - .5) - .25) / w);
    }
  `,
};
export const getElementOfPermutation: ShaderModule = {
  requirements: [],
  code: `
    /*
      getElementOfPermutation produces a poor-man's permutation of the numbers
      [1, ..., sequenceLength] and returns the index-th element.
      The "permutation" is generated using primitive roots.
      Example:
        When calling
          getElementOfPermutation(3, 7, 3)
        an implicit sequence of
          7, 2, 6, 4, 5, 1, 3
        is accessed at index 3 to return a value.
        Thus, 4 is returned.

      Additional explanation:
      3 is a primitive root modulo 7. This fact can be used to generate
      the following pseudo-random sequence by calculating
      primitiveRoot**index % sequenceLength:
      3, 2, 6, 4, 5, 1, 3
      (see https://en.wikipedia.org/wiki/Primitive_root_modulo_n for a more
      in-depth explanation).
      Since the above sequence contains 7 elements (as requested), but exactly *one*
      collision (the first and last elements will always be the same), we swap the
      first element with 7.

      To achieve a diverse combination with little collisions, multiple, dependent
      usages of getElementOfPermutation should use unique sequenceLength values
      which are prime. You can check out this super-dirty code to double-check
      collisions:
        https://gist.github.com/philippotto/88487cddcff049c2aac70b69041efacf

      Sample primitiveRoots for different prime sequenceLengths are:
      sequenceLength=13.0, seed=2
      sequenceLength=17.0, seed=3
      sequenceLength=19.0, seed=2
      More primitive roots for different prime values can be looked up online.
    */
    float getElementOfPermutation(float index, float sequenceLength, float primitiveRoot) {
      float oneBasedIndex = mod(index, sequenceLength) + 1.0;
      float isFirstElement = float(oneBasedIndex == 1.0);

      float sequenceValue = mod(pow(primitiveRoot, oneBasedIndex), sequenceLength);

      return
        // Only use sequenceLength if the requested element is the first of the sequence
        (isFirstElement) * sequenceLength
        // Otherwise, return the actual sequenceValue
        + (1. - isFirstElement) * sequenceValue;
    }
  `,
};

export function getPermutation(sequenceLength: number, primitiveRoot: number) {
  return _.range(sequenceLength).map((idx) =>
    jsGetElementOfPermutation(idx, sequenceLength, primitiveRoot),
  );
}

// See the shader-side implementation of getElementOfPermutation in segmentation.glsl.js
// for a detailed description.
export function jsGetElementOfPermutation(
  index: number,
  sequenceLength: number,
  primitiveRoot: number,
): number {
  const oneBasedIndex = (index % sequenceLength) + 1.0;
  const isFirstElement = oneBasedIndex === 1.0;

  // The GLSL implementation of pow is 2**(y * log2(x)) in which
  // intermediate results can suffer from precision loss. The following
  // code mimics this behavior to get a consistent coloring in GLSL and
  // JS.
  const imprecise = (x: number) => new Float32Array([x])[0];

  function glslPow(x: number, y: number) {
    return Math.floor(imprecise(2 ** (y * imprecise(Math.log2(x)))));
  }

  const sequenceValue = glslPow(primitiveRoot, oneBasedIndex) % sequenceLength;
  // Only use sequenceLength if the requested element is the first of the sequence
  // Otherwise, return the actual sequenceValue
  return isFirstElement ? sequenceLength : sequenceValue;
}
export const inverse: ShaderModule = {
  requirements: [],
  code: `
    // https://github.com/glslify/glsl-inverse/blob/master/index.glsl
    mat4 inverseMatrix(mat4 m) {
      float
        a00 = m[0][0], a01 = m[0][1], a02 = m[0][2], a03 = m[0][3],
        a10 = m[1][0], a11 = m[1][1], a12 = m[1][2], a13 = m[1][3],
        a20 = m[2][0], a21 = m[2][1], a22 = m[2][2], a23 = m[2][3],
        a30 = m[3][0], a31 = m[3][1], a32 = m[3][2], a33 = m[3][3],

        b00 = a00 * a11 - a01 * a10,
        b01 = a00 * a12 - a02 * a10,
        b02 = a00 * a13 - a03 * a10,
        b03 = a01 * a12 - a02 * a11,
        b04 = a01 * a13 - a03 * a11,
        b05 = a02 * a13 - a03 * a12,
        b06 = a20 * a31 - a21 * a30,
        b07 = a20 * a32 - a22 * a30,
        b08 = a20 * a33 - a23 * a30,
        b09 = a21 * a32 - a22 * a31,
        b10 = a21 * a33 - a23 * a31,
        b11 = a22 * a33 - a23 * a32,

        det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

      return mat4(
        a11 * b11 - a12 * b10 + a13 * b09,
        a02 * b10 - a01 * b11 - a03 * b09,
        a31 * b05 - a32 * b04 + a33 * b03,
        a22 * b04 - a21 * b05 - a23 * b03,
        a12 * b08 - a10 * b11 - a13 * b07,
        a00 * b11 - a02 * b08 + a03 * b07,
        a32 * b02 - a30 * b05 - a33 * b01,
        a20 * b05 - a22 * b02 + a23 * b01,
        a10 * b10 - a11 * b08 + a13 * b06,
        a01 * b08 - a00 * b10 - a03 * b06,
        a30 * b04 - a31 * b02 + a33 * b00,
        a21 * b02 - a20 * b04 - a23 * b00,
        a11 * b07 - a10 * b09 - a12 * b06,
        a00 * b09 - a01 * b07 + a02 * b06,
        a31 * b01 - a30 * b03 - a32 * b00,
        a20 * b03 - a21 * b01 + a22 * b00) / det;
    }
  `,
};
export const div: ShaderModule = {
  requirements: [],
  code: `
    float div(float a, float b) {
      return floor(a / b);
    }

    vec3 div(vec3 a, float b) {
      return floor(a / b);
    }
  `,
};
export const isNan: ShaderModule = {
  requirements: [],
  code: `
    bool isNan(float val) {
      // https://stackoverflow.com/questions/9446888/best-way-to-detect-nans-in-opengl-shaders
      return !(val < 0.0 || 0.0 < val || val == 0.0);
      // important: some nVidias failed to cope with version below.
      // Probably wrong optimization.
      /*return ( val <= 0.0 || 0.0 <= val ) ? false : true;*/
    }
  `,
};
export const transDim: ShaderModule = {
  code: `
    // Similar to the transDim function in dimensions.js, this function transposes dimensions for the current plane.
    vec3 transDim(vec3 array) {
      if (planeID == <%= OrthoViewIndices.PLANE_XY %>) {
        return array;
      } else if (planeID == <%= OrthoViewIndices.PLANE_YZ %>) {
        return vec3(array.z, array.y, array.x); // [2, 1, 0]
      } else if (planeID == <%= OrthoViewIndices.PLANE_XZ %>) {
        return vec3(array.x, array.z, array.y); // [0, 2, 1]
      } else {
        return vec3(0.0, 0.0, 0.0);
      }
    }
  `,
};
export const getW: ShaderModule = {
  code: `
    float getW(vec3 vector) {
      if (planeID == <%= OrthoViewIndices.PLANE_XY %>) {
        return vector[2];
      } else if (planeID == <%= OrthoViewIndices.PLANE_YZ %>) {
        return vector[0];
      } else if (planeID == <%= OrthoViewIndices.PLANE_XZ %>) {
        return vector[1];
      }
      return 0.0;
    }
  `,
};
export const isFlightMode: ShaderModule = {
  code: `
    bool isFlightMode() {
      return viewMode == <%= ViewModeValuesIndices.Flight %>;
    }
  `,
};

export const almostEq: ShaderModule = {
  code: `
    // These functions are useful for debugging.
    bool almostEq(vec3 x, vec3 y, float thresh) {
      vec3 diff = abs(x - y);
      return diff.x <= thresh && diff.y <= thresh && diff.z <= thresh;
    }

    bool almostEq(vec3 x, vec3 y, vec3 thresh) {
      vec3 diff = abs(x - y);
      return diff.x <= thresh.x && diff.y <= thresh.y && diff.z <= thresh.z;
    }

    bool almostEq(float x, float y, float thresh) {
      float diff = abs(x - y);
      return diff <= thresh;
    }
  `,
};

export const scaleToFloat: ShaderModule = {
  code: `
    float scaleIntToFloat(int x, int a, int b) {
      // Convert to uint for safer calculations
      uint ux = uint(x);
      uint ua = uint(a);
      uint ub = uint(b);

      // Calculate the range and offset
      uint range = ub - ua;
      uint offset = ux - ua;

      if (range == 0u) {
        return 0.0;
      }

      // Normalize to [0, 1] as a float
      return float(offset) / float(range);
    }

    vec3 scaleFloatToFloat(vec3 x, float a, float b) {
      if (a == b) {
        return vec3(0.0);
      }

      if (b - a < pow(2., 126.)) {
        // "Small" intervals can be used for scaling without
        // any special care.
        return (x - a) / (b - a);
      } else {
        // For large intervals, floating point precision can collapse
        // to 0. Therefore, we make all values a bit smaller before
        // doing further arithmetic.
        float mul = 0.25;
        vec3 nom = mul * x - mul * a;
        float denom = mul * b - mul * a;
        return nom / denom;
      }
    }
  `,
};

export function formatNumberAsGLSLFloat(aNumber: number): string {
  if (aNumber % 1 === 0) {
    // Append ".0" via toFixed
    return aNumber.toFixed(1);
  } else {
    // It is already a floating point number, so we can use toString.
    return aNumber.toString();
  }
}

export function glslTypeForElementClass(elementClass: ElementClass) {
  if (elementClass === "uint32" || elementClass === "uint64") {
    return "uint";
  } else if (elementClass === "int32" || elementClass === "int64") {
    return "int";
  }
  return "float";
}
