define gen_build
BUILD_DIR_$(BUILD_NAME) := $(1)

ifneq ($(TB_SOURCE),)
$(foreach x, $(TB_SOURCE), \
	$(eval $(call gen_build_next, $(x), $$(BUILD_DIR_$(BUILD_NAME)))) \
)
endif
endef

define gen_build_next
ifeq ($(suffix $(1)),.v)
.PHONY: build-iv-$(basename $(notdir $(1)))
build-iv-$(basename $(notdir $(1))):
	cd $(2) && \
	iverilog -o $(basename $(notdir $(1))).out -DVCD_DUMP=1 $(1) $(TB_INCLUDE) && \
	vvp $(basename $(notdir $(1))).out
endif

ifeq ($(suffix $(1)),.cpp)
.PHONY: build-v-$(basename $(notdir $(1)))
build-v-$(basename $(notdir $(1))):
	cd $(2) && \
	verilator -Wall --cc $(TB_INCLUDE) --trace
endif
endef