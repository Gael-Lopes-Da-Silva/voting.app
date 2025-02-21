<div align="center">
	<h1>Voting App</h1>
    <a href="https://github.com/Gael-Lopes-Da-Silva/voting.app">https://github.com/Gael-Lopes-Da-Silva/voting.app</a>
</div>


Description
------------------------------------------------------------------

A tiny project to vote between cats and dog. The project work with two database (postgre and redis). It is mainly a docker learning project.


Usage
------------------------------------------------------------------

To recover the application, do the following:
~~~sh
git clone https://github.com/Gael-Lopes-Da-Silva/voting.app
cd voting.app
~~~

To deploy the application, do the following (In a git bash for windows):
~~~sh
./scripts/deploy.sh # Or bash ./scripts/deploy.sh
~~~

To stop the application without deleting data, do the following (In a git bash for windows):
~~~sh
./scripts/stop.sh # Or bash ./scripts/stop.sh
~~~

To reset the application and delete the data, do the following (In a git bash for windows):
~~~sh
./scripts/reset.sh # Or bash ./scripts/reset.sh
~~~

After deploying the application, you can access it throught the following urls:
- [http://localhost:8080](http://localhost:8080) for the voting app.
- [http://localhost:8888](http://localhost:8888) for the result app.


Documentations
------------------------------------------------------------------

The following is a documentation on how to setup a docker swarm cluster for this app.
- [Swarm documentation in english](./docs/SWARM_EN.md)
- [Swarm documentation in french](./docs/SWARM_FR.md)

The following is a documentation on the changes made to the source code.
- [Changes log in english](./docs/CHANGELOG_EN.md)
- [Changes log in french](./docs/CHANGELOG_FR.md)
