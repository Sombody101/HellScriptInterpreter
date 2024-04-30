# Check for dotnet installation (adjust error message as needed)
ifeq (, $(shell which dotnet))
    $(error .Net not installed (try `sudo apt install dotnet-sdk-8.0'))
endif

CS_PROJ := ./BashHellScript/BashHellScript.csproj

COMMON_FLAGS := -c Release

WIN_ARCH := win-x64
LIN_ARCH := linux-x64

OUT_DIR := ./bin

.PHONY: all  lin clean

# win:
#     @echo "Building for Windows-x64"
#     dotnet publish $(COMMON_FLAGS) -r $(WIN_ARCH) $(CS_PROJ) -o $(OUT_DIR)/win-x64

lin:
	@echo "Building for Linux-x64"
	dotnet publish $(COMMON_FLAGS) -r $(LIN_ARCH) $(CS_PROJ) -o $(OUT_DIR)/linux-x64

clean:
	@echo "Cleaning up..."
	@rm -rf $(OUT_DIR)

all: lin #win
