/*
 * calcDp_terminate.c
 *
 * Code generation for function 'calcDp_terminate'
 *
 * C source code generated on: Sat Nov 17 15:52:36 2012
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calcDp.h"
#include "calcDp_terminate.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void calcDp_atexit(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void calcDp_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (calcDp_terminate.c) */