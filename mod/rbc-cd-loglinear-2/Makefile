include ../../matlab.mk
include ../header.mk

rbcdata.mat: model.mod
	@echo "Simulate RBC model with Cobb Douglas production function (linear approximation)..."
	@$(MATLAB)  -nosplash -nodisplay -r "addpath $(DYNARE_PATH); addpath $(MTOOLS_PATH); dynare model; exit" > /dev/null
	@mv model_results.mat results.mat
	@$(MAKE) clean

clean:
	@echo "Remove useless generated files..."
	@rm -rf model
	@rm -f model_dynamic.m model_static.m model_steadystate2.m model.m model_set_auxiliary_variables.m
	@rm -f model.log *.eps

cleanall: clean
	@echo "Remove all generated files..."
	@rm -f rbcdata.mat
	@rm -f results.mat
