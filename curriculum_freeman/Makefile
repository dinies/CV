.PHONY : all latex view clean distclean

TARGET=main
SOURCE=$(TARGET).tex


latex:
	xelatex $(SOURCE)
	cp $(TARGET).pdf ~/exchange/cv_freeman.pdf

view:
	xdg-open $(TARGET).pdf &

all: latex view


clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out  

distclean:clean
	rm -f $(TARGET).pdf
