
# Simulating with GTKwave
define gtkwave_sim_target 
BUILD_DIR_$(BUILD_NAME) := $(1)

ifneq ($(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.vcd)),)
.PHONY: gtk-$(BUILD_NAME)-vcd
gtk-$(BUILD_NAME)-vcd:
	gtkwave $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.vcd))

ifneq ($(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.gtkw)),)
.PHONY: gtk-$(BUILD_NAME)-$(notdir $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.gtkw)))
gtk-$(BUILD_NAME)-$(notdir $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.gtkw))):
	gtkwave $(strip $(wildcard $(BUILD_DIR_$(BUILD_NAME))/*.gtkw))
endif

endif
endef
