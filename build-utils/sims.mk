
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

# Build Process for compiling testbenches
define gen_build_target
BUILD_DIR_$(BUILD_NAME) := $(1)

ifneq ($(TB_SOURCE),)
.PHONY: build-$(BUILD_NAME)
build-$(BUILD_NAME):
	cd $$(BUILD_DIR_$(BUILD_NAME)) && \
	iverilog -o $(BUILD_NAME).out -DVCD_DUMP=1 $(TB_SOURCE) $(TB_INCLUDE) && \
	vvp $(BUILD_NAME).out
endif
endef

# Simulating with GTKwave
define gtkwave_sim_target 
BUILD_DIR_$(BUILD_NAME) := $(1)

ifneq ($(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.vcd)),)
.PHONY: gtk-$(BUILD_NAME)-vcd
gtk-$(BUILD_NAME)-vcd:
	gtkwave $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.vcd))

ifneq ($(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.gtkw)),)
.PHONY: gtk-$(BUILD_NAME)-$(notdir $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.gtkw)))
gtk-$(BUILD_NAME)-$(notdir $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.gtkw))):
	gtkwave $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.gtkw))
endif

endif
endef


# @echo $(notdir $(wildcard $(BUILD_DIR_$(BUILD_NAME))*.vcd))
# ------------------------------------------------------------ #

# Make Process
$(foreach x, $(VALID_SIMS_FOLDERS), \
	$(eval $(call sourcing_mk, $(x)/tb.mk)) \
	$(eval $(call gen_build_target, $(x))) \
	$(eval $(call gtkwave_sim_target, $(x))) \
)

# Clean build
clean:
	$(foreach x,$(VALID_SIMS_FOLDERS), \
		rm -f $(x)*_tb.vcd && \
		rm -f $(x)*.out \
	)