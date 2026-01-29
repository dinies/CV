.PHONY : all latex latexcp view clean distclean

TARGET=main
SOURCE=$(TARGET).tex
FILE_NAME=job_resources_2026.pdf
OUTPUT_FOLDER=~/exchange/

latex:
	pdflatex $(SOURCE)

latexcp:
	pdflatex $(SOURCE)
	cp $(TARGET).pdf $(OUTPUT_FOLDER)$(FILE_NAME)

view:
	xdg-open $(TARGET).pdf &

all: latex view


clean:
	rm -f $(TARGET).aux $(TARGET).log $(TARGET).out

distclean:clean
	rm -f $(TARGET).pdf
