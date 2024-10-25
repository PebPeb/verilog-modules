include $(PROJECT_ROOT)/build-utils/iv.mk
include $(PROJECT_ROOT)/build-utils/gtkwave.mk

# Get all dirs in 
# SIMS_FOLDERS := $(wildcard $(PROJECT_ROOT)/*/*/)
SIMS_FOLDERS := $(shell find $(PROJECT_ROOT) -type d -print)/

# Checks for tb.mk
# For every folder check for tb.mk if found add to VALID_SIMS_FOLDERS
VALID_SIMS_FOLDERS :=
$(foreach folder,$(SIMS_FOLDERS),$(if $(wildcard $(folder)/tb.mk),$(eval VALID_SIMS_FOLDERS += $(folder))))


# ------------------------------------------------------------ #
# Source all tb.mk files
define sourcing_mk 
include $(1)
endef

# ------------------------------------------------------------ #

# Make Process
$(foreach x, $(VALID_SIMS_FOLDERS), \
	$(eval $(call sourcing_mk, $(x)/tb.mk)) \
	$(eval $(call gen_build_target, $(x), $(TB_SOURCE))) \
	$(eval $(call gtkwave_sim_target, $(x))) \
)

# Clean build
clean:
	$(foreach x,$(VALID_SIMS_FOLDERS), \
		rm -f $(x)/*.vcd && \
		rm -f $(x)/*.out && \
		rm -fr $(x)/obj_dir \
	)