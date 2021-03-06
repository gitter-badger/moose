# This simulation uses the piece-wise linear strain hardening model
# with the incremental small strain formulation; incremental small strain
# is required to produce the strain_increment for the DiscreteRadialReturnStressIncrement
# class, which handles the calculation of the stress increment to return
# to the yield surface in a J2 (isotropic) plasticity problem.
#
#  This test is used to check the error messages in the discrete radial return
# model DiscreteRRIsotropicPlasticity; cli_args are used to check all of the
# error messages in the DiscreteRRIsotropicPlasticity model.

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  order = FIRST
  family = LAGRANGE
[]

[Variables]
  [./disp_x]
  [../]

  [./disp_y]
  [../]

  [./disp_z]
  [../]
[]


[AuxVariables]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./plastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./plastic_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]


[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t*(0.0625)
  [../]
  [./harden_func]
    type = PiecewiseLinear
    x = '0  0.0003 0.0007 0.0009'
    y = '50    52    54    56'
  [../]
[]

[Kernels]
  [./TensorMechanics]
    use_displaced_mesh = true
  [../]
[]


[AuxKernels]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]

  [./plastic_strain_yy]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_strain_yy
    index_i = 1
    index_j = 1
  [../]

  [./plastic_strain_xx]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_strain_xx
    index_i = 0
    index_j = 0
  [../]

  [./plastic_strain_zz]
    type = RankTwoAux
    rank_two_tensor = plastic_strain
    variable = plastic_strain_zz
    index_i = 2
    index_j = 2
  [../]
 []


[BCs]
  [./y_pull_function]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function = top_pull
  [../]

  [./x_bot]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]

  [./y_bot]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]

  [./z_bot]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]
[]

[Materials]
  [./elasticity_tensor]
    block = 0
  [../]
  [./small_strain]
    type = ComputeIncrementalSmallStrain
    block = 0
  [../]


  [./isotropic_plasticity_recompute]
    type = RecomputeRadialReturnIsotropicPlasticity
    block = 0
    relative_tolerance = 1e-25
    absolute_tolerance = 1e-5
  [../]

  [./radial_return_stress]
    type = ComputeReturnMappingStress
    block = 0
    return_mapping_stress_model = 'isotropic_plasticity_recompute'
  [../]
[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  line_search = 'none'

  l_max_its = 100
  nl_max_its = 100
  nl_rel_tol = 1e-18
  nl_abs_tol = 1e-10
  l_tol = 1e-12

  start_time = 0.0
  end_time = 0.025
  dt = 0.00125
  dtmin = 0.0001
[]


[Outputs]
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]
