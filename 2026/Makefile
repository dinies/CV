.PHONY : all latex latexcp view clean distclean

TARGET=main
SOURCE=$(TARGET).tex

latex:
	pdflatex $(SOURCE)

latexcp:
	pdflatex $(SOURCE)
	cp $(TARGET).pdf ~/exchange/CV_Edoardo_Ghini.pdf

view:
	xdg-open $(TARGET).pdf &

all: latex view


clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out

distclean:clean
	rm -f $(TARGET).pdf
