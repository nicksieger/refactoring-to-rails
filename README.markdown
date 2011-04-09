# Refactoring to Rails

This is a project to demonstrate how you might refactor a legacy Java
project to use Rails.

The entire repository history is intended to be read start-to-finish.
Each commit message is annotated with the goals of that particular
step and what to expect. If you simply copy or imitate code from a
particular snapshot without understanding how it got there, you're
just practicing [cargo][c1] [cult][c2] [programming][c3] :).

We're using the Spring-MVC-based "Petclinic" application as the
project subject to the refactoring. We sourced the code of the
application from [this subversion repository][svn].

There are three versions of the refactoring: `small`, `medium` and
`large`. Each version is stored on a different branch in this
repository. The three branches build upon each other in succession.
The size name of each of the refactorings is an indicator to the
amount of deviation from the original Java-only Spring MVC project.

## Getting Started

To play with this code, you should [install JRuby][jruby], and then
install Bundler with `gem install bundler`.

You will also need MySQL installed. You'll need to do the one-time
step of creating the `petclinic` database. Assuming the default MySQL
development setup of a root user with no password, run `rake
db:create` to create the petclinic database. (Alternately, you can log
into the mysql console manually and load the file
`src/main/resources/db/mysql/initDB.txt`.)

At any point in the history, you should be able to:

- `bundle install`: This ensures that you have all the gems needed to
  run the project.
- `rake`: This runs the test suite. See also the output of `rake -T`
  to see all available tasks.

[svn]: https://src.springframework.org/svn/spring-samples/petclinic/trunk
[c1]: http://c2.com/cgi/wiki?CargoCultProgramming
[c2]: http://c2.com/cgi/wiki?CopyAndPasteProgramming
[c3]: http://c2.com/cgi/wiki?VoodooChickenCoding
[jruby]: http://jruby.org/getting-started
