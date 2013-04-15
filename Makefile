PREFIX=/usr/local

SCRIPTS=\
		  update-global-ctags\
		  attach-displays\
		  backlight\
		  bu\
		  ciph\
		  clean\
		  def\
		  do-each\
		  dyninput\
		  extract\
		  get-packages\
		  git-du\
		  git-perm-rm\
		  gits\
		  grade\
		  growth\
		  last-used\
		  latexize\
		  low-power\
		  nf\
		  note\
		  pdf\
		  rep\
		  rot13\
		  rs-parallel\
		  run-always\
		  run-java\
		  seq-rename\
		  th\
		  th-clear\
		  th-ls\
		  th-undo\
		  translate\
		  weagle\
		  dirty\
		  split-args\
		  du-sorted\
		  d

.PHONY: all install uninstall check
.SILENT: all install uninstall check

all: check

check:
	for script in ${SCRIPTS} ; do \
		if ! diff -q "$$script" "${DESTDIR}${PREFIX}/bin/$$script" ; then\
			echo "$$script has changes." ; \
		fi \
	done

install:
	for script in ${SCRIPTS} ; do \
		if ! diff -q "$$script" "${DESTDIR}${PREFIX}/bin/$$script" &>/dev/null ; then\
			if [ -f "${DESTDIR}${PREFIX}/bin/$$script" ] ; then \
				echo "updated '$$script'" ; \
			else \
				echo "added '$$script'" ; \
			fi ; \
			install "$$script" ${DESTDIR}${PREFIX}/bin ; \
		fi \
	done

uninstall:
	for script in ${SCRIPTS} ; do \
		rm -vf ${DESTDIR}${PREFIX}/bin/$$script ; \
	done