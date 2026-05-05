SRC_DIR  = ./
BUILD_DIR = ../../build
MAIN      = main
LATEXMK   = latexmk
LATEXMKOPTS = -pdf -shell-escape -interaction=nonstopmode -f -output-directory=$(BUILD_DIR)

.PHONY: all clean

all:
	$(LATEXMK) $(LATEXMKOPTS) $(SRC_DIR)/$(MAIN).tex

clean:
	$(LATEXMK) -output-directory=$(BUILD_DIR) -C $(SRC_DIR)/$(MAIN).tex
	rm -rf $(BUILD_DIR)/_minted-$(MAIN) $(SRC_DIR)/_minted-$(MAIN)
