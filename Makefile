help:
	@echo "Following rules are available:"
	@echo " "
	@echo "    dynare          Updates and compiles the dynare submodule."
	@echo "    submodules      Install or update the submodules."
	@echo " "

dynare: submodules
	@echo "Compile dynare..."
	@./scripts/dynare.sh

submodules:
	@echo "Install or update submodules..."
	@git submodule update --init --recursive 
