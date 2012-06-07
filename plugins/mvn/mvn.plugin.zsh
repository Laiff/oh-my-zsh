function listMavenCompletions { 
	 reply=(
		cli:execute cli:execute-phase archetype:generate generate-sources compile clean install test test-compile deploy package cobertura:cobertura jetty:run gwt:run gwt:debug -DskipTests -Dmaven.test.skip=true -DarchetypeCatalog=http://tapestry.formos.com/maven-snapshot-repository -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`); 
}

compctl -K listMavenCompletions mvn

# clorize maven output
mvn-color()
{
  # Filter mvn output using sed
  mvn $@ | sed -e "s/\(\[INFO\]\ \-.*\)/^[[36;01m\1^[[m/g" \
               -e "s/\(\[INFO\]\ Building .*\)/^[[36;01m\1^[[m/g" \
               -e "s/\(\[INFO\]\ \[.*\)/^[01m\1^[[m/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESS\)/^[[01;32m\1^[[m/g" \
               -e "s/\(\[INFO\]\ BUILD FAILURE\)/^[[01;31m\1^[[m/g" \
               -e "s/\(\[WARNING\].*\)/^[[01;33m\1^[[m/g" \
               -e "s/\(\[ERROR\].*\)/^[[01;31m\1^[[m/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/^[[32mTests run: \1^[[m, Failures: ^[[01;31m\2^[[m, Errors: ^[[01;31m\3^[[m, Skipped: ^[[01;33m\4^[[m/g"
}
# Override the mvn command with the colorized one.
alias mvn="mvn-color"
