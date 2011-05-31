#ifndef TEMPERATUREAUX_H
#define TEMPERATUREAUX_H

#include "AuxKernel.h"

//Forward Declarations
class TemperatureAux;

template<>
InputParameters validParams<TemperatureAux>();

/** 
 * Temperature is an auxiliary value computed from the total energy
 * and the velocity magnitude (e_i = internal energy, e_t = total energy):
 * T = e_i / c_v
 *   = (e_t - |u|^2/2) / c_v
 */
class TemperatureAux : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  TemperatureAux(const std::string & name, InputParameters parameters);

  virtual ~TemperatureAux() {}
  
protected:
  virtual Real computeValue();

  // The temperature depends on velocities and total energy
  VariableValue & _rho;
  VariableValue & _u_vel;
  VariableValue & _v_vel;
  VariableValue & _w_vel;
  VariableValue & _rhoe;

  // Specific heat at constant volume, treated as a single
  // constant value.
  Real _cv;

};

#endif //VELOCITYAUX_H
