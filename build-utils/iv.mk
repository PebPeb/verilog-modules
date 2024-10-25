
# Build Process for compiling testbenches
# ---- #
define gen_build_target
BUILD_DIR_$(BUILD_NAME) := $(1)

ifneq ($(TB_SOURCE),)
$(foreach x, $(TB_SOURCE), \
	$(eval $(call icarus_verilog, $(x), $$(BUILD_DIR_$(BUILD_NAME)))) \
)
endif
endef

define icarus_verilog
ifeq ($(suffix $(1)),.v)
.PHONY: build-iv-$(BUILD_NAME)_$(basename $(notdir $(1)))
build-iv-$(BUILD_NAME)_$(basename $(notdir $(1))):
	cd $(2) && \
	iverilog -o $(basename $(notdir $(1))).out -DVCD_DUMP=1 $(1) $(TB_INCLUDE) && \
	vvp $(basename $(notdir $(1))).out
endif
endef
# ---- #