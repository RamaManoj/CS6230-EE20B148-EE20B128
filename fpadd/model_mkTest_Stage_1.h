/*
 * Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
 * 
 * On Sat Dec  9 12:17:44 IST 2023
 * 
 */

/* Generation options: */
#ifndef __model_mkTest_Stage_1_h__
#define __model_mkTest_Stage_1_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"

#include "bs_model.h"
#include "mkTest_Stage_1.h"

/* Class declaration for a model of mkTest_Stage_1 */
class MODEL_mkTest_Stage_1 : public Model {
 
 /* Top-level module instance */
 private:
  MOD_mkTest_Stage_1 *mkTest_Stage_1_instance;
 
 /* Handle to the simulation kernel */
 private:
  tSimStateHdl sim_hdl;
 
 /* Constructor */
 public:
  MODEL_mkTest_Stage_1();
 
 /* Functions required by the kernel */
 public:
  void create_model(tSimStateHdl simHdl, bool master);
  void destroy_model();
  void reset_model(bool asserted);
  void get_version(char const **name, char const **build);
  time_t get_creation_time();
  void * get_instance();
  void dump_state();
  void dump_VCD_defs();
  void dump_VCD(tVCDDumpType dt);
};

/* Function for creating a new model */
extern "C" {
  void * new_MODEL_mkTest_Stage_1();
}

#endif /* ifndef __model_mkTest_Stage_1_h__ */