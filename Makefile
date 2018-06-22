#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

export TARGET		:=	$(shell basename $(CURDIR))
export TOPDIR		:=	$(CURDIR)


.PHONY: arm7/$(TARGET).elf arm9/$(TARGET).elf

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
all: $(TARGET).nds

#---------------------------------------------------------------------------------
$(TARGET).nds	:	arm7/$(TARGET).elf arm9/$(TARGET).elf dldi/dsisd.dldi
	ndstool	-c $(TARGET).nds -7 arm7/$(TARGET).elf -9 arm9/$(TARGET).elf \
			-b icon.bmp "GBARUNNER2;GBA hypervisor for NDS;made by Gericom" \
			-g KGBE 01 "GBARUNNER2" -z 80040000 -u 00030004 -a 00000138 -p 00000001 
	dlditool dldi/dsisd.dldi $(TARGET).nds
	cp $(TARGET).nds title/00030004/4b474245/content/00000000.app
	#python patch_ndsheader_dsiware.py $(CURDIR)/$(TARGET).nds 

#---------------------------------------------------------------------------------
arm7/$(TARGET).elf:
	$(MAKE) -C arm7
	
#---------------------------------------------------------------------------------
arm9/$(TARGET).elf:
	$(MAKE) -C arm9
    
#---------------------------------------------------------------------------------	
dldi/dsisd.dldi:
	@$(MAKE) -C dldi

#---------------------------------------------------------------------------------
clean:
	$(MAKE) -C arm9 clean
	$(MAKE) -C arm7 clean
	$(MAKE) -C dldi clean
	rm -f $(TARGET).nds $(TARGET).arm7 $(TARGET).arm9
	rm title/00030004/4b474245/content/00000000.app 
