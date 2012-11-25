/*
 * V1.c
 *
 * Code generation for function 'V1'
 *
 * C source code generated on: Thu Nov 22 11:00:22 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "V1.h"
#include "V1_emxutil.h"
#include "power.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 5, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtRSInfo b_emlrtRSI = { 6, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtRSInfo c_emlrtRSI = { 11, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo d_emlrtRSI = { 14, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo e_emlrtRSI = { 26, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo f_emlrtRSI = { 39, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtRSInfo g_emlrtRSI = { 11, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtRSInfo h_emlrtRSI = { 49, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtMCInfo emlrtMCI = { 14, 5, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtMCInfo b_emlrtMCI = { 50, 9, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtMCInfo c_emlrtMCI = { 49, 15, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtRTEInfo emlrtRTEI = { 1, 18, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtRTEInfo b_emlrtRTEI = { 17, 5, "abs",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/elfun/abs.m" };

static emlrtRTEInfo c_emlrtRTEI = { 20, 9, "eml_li_find",
  "/Applications/MATLAB_R2012b.app/toolbox/eml/lib/matlab/eml/eml_li_find.m" };

static emlrtECInfo emlrtECI = { -1, 5, 24, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtECInfo b_emlrtECI = { -1, 6, 32, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtECInfo c_emlrtECI = { -1, 6, 53, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtECInfo d_emlrtECI = { -1, 6, 17, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtECInfo e_emlrtECI = { -1, 5, 5, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtECInfo f_emlrtECI = { -1, 6, 5, "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m" };

static emlrtBCInfo emlrtBCI = { -1, -1, 5, 5, "V", "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m", 0 };

static emlrtBCInfo b_emlrtBCI = { -1, -1, 5, 24, "r", "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m", 0 };

static emlrtBCInfo c_emlrtBCI = { -1, -1, 6, 32, "r", "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m", 0 };

static emlrtBCInfo d_emlrtBCI = { -1, -1, 6, 53, "r", "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m", 0 };

static emlrtBCInfo e_emlrtBCI = { -1, -1, 6, 5, "V", "V1",
  "/Users/schaluck/Documents/MATLAB/MT/1D/V1.m", 0 };

/* Function Declarations */
static void check_forloop_overflow_error(boolean_T overflow);
static void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y);
static void error(const mxArray *b, emlrtMCInfo *location);
static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location);

/* Function Definitions */
static void check_forloop_overflow_error(boolean_T overflow)
{
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 34 };

  const mxArray *m1;
  static const char_T cv0[34] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o',
    'l', 'b', 'o', 'x', ':', 'i', 'n', 't', '_', 'f', 'o', 'r', 'l', 'o', 'o',
    'p', '_', 'o', 'v', 'e', 'r', 'f', 'l', 'o', 'w' };

  const mxArray *b_y;
  static const int32_T iv1[2] = { 1, 23 };

  static const char_T cv1[23] = { 'c', 'o', 'd', 'e', 'r', '.', 'i', 'n', 't',
    'e', 'r', 'n', 'a', 'l', '.', 'i', 'n', 'd', 'e', 'x', 'I', 'n', 't' };

  if (!overflow) {
  } else {
    emlrtPushRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
    y = NULL;
    m1 = mxCreateCharArray(2, iv0);
    emlrtInitCharArray(34, m1, cv0);
    emlrtAssign(&y, m1);
    b_y = NULL;
    m1 = mxCreateCharArray(2, iv1);
    emlrtInitCharArray(23, m1, cv1);
    emlrtAssign(&b_y, m1);
    error(message(y, b_y, &b_emlrtMCI), &c_emlrtMCI);
    emlrtPopRtStackR2012b(&h_emlrtRSI, emlrtRootTLSGlobal);
  }
}

static void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y)
{
  int32_T n;
  int32_T k;
  boolean_T b0;
  int32_T i;
  const mxArray *b_y;
  const mxArray *m0;
  int32_T j;
  n = x->size[0] * x->size[1];
  emlrtPushRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  k = 0;
  emlrtPushRtStackR2012b(&f_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  if (1 > n) {
    b0 = FALSE;
  } else {
    b0 = (n > 2147483646);
  }

  check_forloop_overflow_error(b0);
  emlrtPopRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPopRtStackR2012b(&f_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= n; i++) {
    if (x->data[i - 1]) {
      k++;
    }
  }

  emlrtPopRtStackR2012b(&c_emlrtRSI, emlrtRootTLSGlobal);
  if (k <= n) {
  } else {
    emlrtPushRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
    b_y = NULL;
    m0 = mxCreateString("Assertion failed.");
    emlrtAssign(&b_y, m0);
    error(b_y, &emlrtMCI);
    emlrtPopRtStackR2012b(&d_emlrtRSI, emlrtRootTLSGlobal);
  }

  j = y->size[0];
  y->size[0] = k;
  emxEnsureCapacity((emxArray__common *)y, j, (int32_T)sizeof(int32_T),
                    &c_emlrtRTEI);
  j = 0;
  emlrtPushRtStackR2012b(&e_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  check_forloop_overflow_error(FALSE);
  emlrtPopRtStackR2012b(&g_emlrtRSI, emlrtRootTLSGlobal);
  emlrtPopRtStackR2012b(&e_emlrtRSI, emlrtRootTLSGlobal);
  for (i = 1; i <= n; i++) {
    if (x->data[i - 1]) {
      y->data[j] = i;
      j++;
    }
  }
}

static void error(const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 0, NULL, 1, &pArray, "error", TRUE,
                        location);
}

static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location)
{
  const mxArray *pArrays[2];
  const mxArray *m3;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 1, &m3, 2, pArrays, "message",
    TRUE, location);
}

void V1(emxArray_real_T *r, emxArray_real_T *V)
{
  uint32_T uv0[2];
  int32_T i0;
  int32_T loop_ub;
  emxArray_real_T *x;
  uint32_T uv1[2];
  emxArray_boolean_T *r0;
  emxArray_int32_T *r1;
  emxArray_boolean_T *r2;
  emxArray_int32_T *r3;
  emxArray_int32_T *r4;
  int32_T i1;
  int32_T i2;
  emxArray_real_T *r5;
  emxArray_boolean_T *b_r;
  emxArray_boolean_T *c_r;
  emxArray_real_T *r6;
  emxArray_real_T *b;
  emxArray_real_T *r7;
  emxArray_boolean_T *d_r;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  for (i0 = 0; i0 < 2; i0++) {
    uv0[i0] = (uint32_T)r->size[i0];
  }

  i0 = V->size[0] * V->size[1];
  V->size[0] = (int32_T)uv0[0];
  emxEnsureCapacity((emxArray__common *)V, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  i0 = V->size[0] * V->size[1];
  V->size[1] = (int32_T)uv0[1];
  emxEnsureCapacity((emxArray__common *)V, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = (int32_T)uv0[0] * (int32_T)uv0[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    V->data[i0] = 0.0;
  }

  b_emxInit_real_T(&x, 2, &emlrtRTEI, TRUE);
  i0 = x->size[0] * x->size[1];
  x->size[0] = r->size[0];
  x->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)x, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    x->data[i0] = r->data[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    uv1[i0] = (uint32_T)r->size[i0];
  }

  i0 = r->size[0] * r->size[1];
  r->size[0] = (int32_T)uv1[0];
  r->size[1] = (int32_T)uv1[1];
  emxEnsureCapacity((emxArray__common *)r, i0, (int32_T)sizeof(real_T),
                    &b_emlrtRTEI);
  i0 = x->size[0] * x->size[1];
  for (loop_ub = 0; loop_ub < i0; loop_ub++) {
    r->data[(int32_T)(1.0 + (real_T)loop_ub) - 1] = muDoubleScalarAbs(x->data
      [(int32_T)(1.0 + (real_T)loop_ub) - 1]);
  }

  emxFree_real_T(&x);
  emxInit_boolean_T(&r0, 2, &emlrtRTEI, TRUE);
  emlrtPushRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  i0 = r0->size[0] * r0->size[1];
  r0->size[0] = r->size[0];
  r0->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)r0, i0, (int32_T)sizeof(boolean_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    r0->data[i0] = ((real_T)(0.5 > r->data[i0]) >= 0.4);
  }

  emxInit_int32_T(&r1, 1, &emlrtRTEI, TRUE);
  emxInit_boolean_T(&r2, 2, &emlrtRTEI, TRUE);
  eml_li_find(r0, r1);
  emlrtPopRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  emlrtMatrixMatrixIndexCheckR2012b(*(int32_T (*)[2])r->size, 2, *(int32_T (*)[1])
    r1->size, 1, &emlrtECI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  i0 = r2->size[0] * r2->size[1];
  r2->size[0] = r->size[0];
  r2->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)r2, i0, (int32_T)sizeof(boolean_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  emxFree_boolean_T(&r0);
  for (i0 = 0; i0 < loop_ub; i0++) {
    r2->data[i0] = (0.5 > r->data[i0]);
  }

  emxInit_int32_T(&r3, 1, &emlrtRTEI, TRUE);
  emxInit_int32_T(&r4, 1, &emlrtRTEI, TRUE);
  eml_li_find(r2, r4);
  i0 = r3->size[0];
  r3->size[0] = r4->size[0];
  emxEnsureCapacity((emxArray__common *)r3, i0, (int32_T)sizeof(int32_T),
                    &emlrtRTEI);
  loop_ub = r4->size[0];
  emxFree_boolean_T(&r2);
  for (i0 = 0; i0 < loop_ub; i0++) {
    i1 = (int32_T)uv0[0] * (int32_T)uv0[1];
    i2 = r4->data[i0];
    r3->data[i0] = emlrtDynamicBoundsCheckFastR2012b(i2, 1, i1, &emlrtBCI,
      emlrtRootTLSGlobal);
  }

  emlrtPopRtStackR2012b(&emlrtRSI, emlrtRootTLSGlobal);
  loop_ub = r1->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    i1 = r->size[0] * r->size[1];
    i2 = r1->data[i0];
    emlrtDynamicBoundsCheckFastR2012b(i2, 1, i1, &b_emlrtBCI, emlrtRootTLSGlobal);
  }

  emxInit_real_T(&r5, 1, &emlrtRTEI, TRUE);
  i0 = r5->size[0];
  r5->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)r5, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = r1->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    r5->data[i0] = 0.0847 * r->data[r1->data[i0] - 1];
  }

  i0 = r3->size[0];
  i1 = r5->size[0];
  emlrtSizeEqCheck1DFastR2012b(i0, i1, &e_emlrtECI, emlrtRootTLSGlobal);
  loop_ub = r5->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    V->data[r3->data[i0] - 1] = r5->data[i0];
  }

  emxFree_int32_T(&r3);
  emxInit_boolean_T(&b_r, 2, &emlrtRTEI, TRUE);
  emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  i0 = b_r->size[0] * b_r->size[1];
  b_r->size[0] = r->size[0];
  b_r->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)b_r, i0, (int32_T)sizeof(boolean_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_r->data[i0] = (r->data[i0] >= 0.5);
  }

  emxInit_boolean_T(&c_r, 2, &emlrtRTEI, TRUE);
  eml_li_find(b_r, r1);
  emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  emlrtMatrixMatrixIndexCheckR2012b(*(int32_T (*)[2])r->size, 2, *(int32_T (*)[1])
    r1->size, 1, &b_emlrtECI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  i0 = c_r->size[0] * c_r->size[1];
  c_r->size[0] = r->size[0];
  c_r->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)c_r, i0, (int32_T)sizeof(boolean_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  emxFree_boolean_T(&b_r);
  for (i0 = 0; i0 < loop_ub; i0++) {
    c_r->data[i0] = (r->data[i0] >= 0.5);
  }

  emxInit_real_T(&r6, 1, &emlrtRTEI, TRUE);
  eml_li_find(c_r, r4);
  emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  emlrtMatrixMatrixIndexCheckR2012b(*(int32_T (*)[2])r->size, 2, *(int32_T (*)[1])
    r4->size, 1, &c_emlrtECI, emlrtRootTLSGlobal);
  i0 = r6->size[0];
  r6->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)r6, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = r1->size[0];
  emxFree_boolean_T(&c_r);
  for (i0 = 0; i0 < loop_ub; i0++) {
    i1 = r->size[0] * r->size[1];
    i2 = r1->data[i0];
    r6->data[i0] = 1.0 - 5.0 * r->data[emlrtDynamicBoundsCheckFastR2012b(i2, 1,
      i1, &c_emlrtBCI, emlrtRootTLSGlobal) - 1];
  }

  emxInit_real_T(&b, 1, &emlrtRTEI, TRUE);
  power(r6, b);
  i0 = b->size[0];
  b->size[0] = b->size[0];
  emxEnsureCapacity((emxArray__common *)b, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = b->size[0];
  emxFree_real_T(&r6);
  for (i0 = 0; i0 < loop_ub; i0++) {
    b->data[i0] *= 0.8;
  }

  emxInit_real_T(&r7, 1, &emlrtRTEI, TRUE);
  i0 = r7->size[0];
  r7->size[0] = r4->size[0];
  emxEnsureCapacity((emxArray__common *)r7, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = r4->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    i1 = r->size[0] * r->size[1];
    i2 = r4->data[i0];
    r7->data[i0] = -4.0 * r->data[emlrtDynamicBoundsCheckFastR2012b(i2, 1, i1,
      &d_emlrtBCI, emlrtRootTLSGlobal) - 1];
  }

  emxInit_boolean_T(&d_r, 2, &emlrtRTEI, TRUE);
  power(r7, r5);
  i0 = b->size[0];
  i1 = r5->size[0];
  emlrtSizeEqCheck1DFastR2012b(i0, i1, &d_emlrtECI, emlrtRootTLSGlobal);
  emlrtPushRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  i0 = d_r->size[0] * d_r->size[1];
  d_r->size[0] = r->size[0];
  d_r->size[1] = r->size[1];
  emxEnsureCapacity((emxArray__common *)d_r, i0, (int32_T)sizeof(boolean_T),
                    &emlrtRTEI);
  loop_ub = r->size[0] * r->size[1];
  emxFree_real_T(&r7);
  for (i0 = 0; i0 < loop_ub; i0++) {
    d_r->data[i0] = (r->data[i0] >= 0.5);
  }

  eml_li_find(d_r, r1);
  i0 = r4->size[0];
  r4->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)r4, i0, (int32_T)sizeof(int32_T),
                    &emlrtRTEI);
  loop_ub = r1->size[0];
  emxFree_boolean_T(&d_r);
  for (i0 = 0; i0 < loop_ub; i0++) {
    i1 = V->size[0] * V->size[1];
    i2 = r1->data[i0];
    r4->data[i0] = emlrtDynamicBoundsCheckFastR2012b(i2, 1, i1, &e_emlrtBCI,
      emlrtRootTLSGlobal);
  }

  emxFree_int32_T(&r1);
  emlrtPopRtStackR2012b(&b_emlrtRSI, emlrtRootTLSGlobal);
  i0 = r4->size[0];
  i1 = b->size[0];
  emlrtSizeEqCheck1DFastR2012b(i0, i1, &f_emlrtECI, emlrtRootTLSGlobal);
  loop_ub = b->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    V->data[r4->data[i0] - 1] = b->data[i0] - r5->data[i0];
  }

  emxFree_int32_T(&r4);
  emxFree_real_T(&b);
  emxFree_real_T(&r5);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (V1.c) */
