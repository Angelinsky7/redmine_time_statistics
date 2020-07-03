# redmine_time_statistics
A plugin for redmine to calculate the percentage of the parent based on the number of closed children

# Installation:

* download one of:
** git: `git clone https://github.com/Angelinsky7/redmine_time_statistics.git plugins/redmine_time_statistics`
* place plugin files into `plugins/redmine_time_statistics` folder (strip possible @-master@ or @-version@ suffix)
* restart Redmine instance

--------------------------------------------------------------------------------

# Compatibility:

* Redmine up to 4.x
* For redmine before 4.x you must patch lib/redmine/subclass_factory.rb to have that 4.1 branch version of it (https://www.redmine.org/projects/redmine/repository/entry/branches/4.1-stable/lib/redmine/subclass_factory.rb#L34)

--------------------------------------------------------------------------------

# Authors:

* Angelinsky7 [https://github.com/Angelinsky7]