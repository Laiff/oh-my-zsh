function listMavenCompletions { 
	 reply=(
		cli:execute cli:execute-phase archetype:generate generate-sources compile clean install test test-compile deploy package cobertura:cobertura jetty:run gwt:run gwt:debug -DskipTests -Dmaven.test.skip=true -DarchetypeCatalog=http://tapestry.formos.com/maven-snapshot-repository -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`); 
}

compctl -K listMavenCompletions mvn

# clorize maven output
mvn-color()
{
  # Filter mvn output using sed
  mvn $@ | sed -e s/\\\(\\\[INFO\\\]\\\ .\*\\\)/$'\033'\\\[38\\\;5\\\;240m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ \\-.\*\\\)/$'\033'\\\[38\\\;5\\\;220m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ \*task-segment.\*\\\)/$'\033'\\\[38\\\;5\\\;220m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ Building\ .\*\\\)/$'\033'\\\[38\\\;5\\\;220m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ \\\[.\*\\\)/$'\033'\\\[38\\\;5\\\;033m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ \\\)\\\(\[a-z\\\-\]\*\\\)\\\+\\\(\.\*\\\ \\\)\\\(SUCCESS\\\ \\\)/$'\033'\\\[38\\\;5\\\;240m\\1$'\033'\\\[38\\\;5\\\;254m\\2$'\033'\\\[38\\\;5\\\;240m\\3$'\033'\\\[38\\\;5\\\;040m\\4/g \
               -e s/\\\(\\\[INFO\\\]\\\ \\\)\\\(\[a-z\\\-\]\*\\\)\\\+\\\(\.\*\\\ \\\)\\\(FAILURE\\\ \\\)/$'\033'\\\[38\\\;5\\\;240m\\1$'\033'\\\[38\\\;5\\\;254m\\2$'\033'\\\[38\\\;5\\\;240m\\3$'\033'\\\[38\\\;5\\\;160m\\4/g \
               -e s/\\\(\\\[INFO\\\]\\\ BUILD\\\ SUCCESSFUL\\\)/$'\033'\\\[38\\\;5\\\;040m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[INFO\\\]\\\ BUILD\\\ FAILURE\\\)/$'\033'\\\[38\\\;5\\\;160m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[WARNING\\\].\*\\\)/$'\033'\\\[38\\\;5\\\;202m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[WARN\\\].\*\\\)/$'\033'\\\[38\\\;5\\\;202m\\1$'\033'\[00m/g \
               -e s/\\\(\\\[ERROR\\\].\*\\\)/$'\033'\\\[38\\\;5\\\;196m\\1$'\033'\[00m/g \
               -e s/Tests\ run:\ \\\(\[\^,\]\*\\\),\ Failures:\ \\\(\[\^,\]\*\\\),\ Errors:\ \\\(\[\^,\]\*\\\),\ Skipped:\ \\\(\[\^,\]\*\\\)/$'\033'\\\[33mTests\ run:\ \1$'\033'\[00m,\ Failures:\ $'\033'\\\[31m\\2$'\033'\[00m,\ Errors:\ $'\033'\\\[31m\\3$'\033'\[00m,\ Skipped:\ $'\033'\\\[36m\\4$'\033'\[00m/g
}
# Override the mvn command with the colorized one. \\\|FAILURE
alias mvn="mvn-color"