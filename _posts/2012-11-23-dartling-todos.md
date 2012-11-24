---
layout: default
title: TodoMVC with
---

![Alt dartling] (/img/dartling2.png)

[TodoMVC] (http://todomvc.com/) is "a project which offers the same Todo application implemented using MV* concepts in most of the popular JavaScript MV* frameworks of today". MV* stands for Model View and * for Controller. [MVC] (http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) is a way (an architecture or a design pattern) of organizing software into a model of data and different views of data that are presented to uses of the software. The controller part handles an interaction between a user and views of the model. 

The Todo application has a simple model (Figure 1) consisting of only one concept (or entity), which is a task (or todo) to be done. Since the model has only one concept, the Task concept is also the only entry (||) point to the model's data. The task concept has the title and completed properties. Both properties may be updated by a user of the application.

![Alt Figure 1: Task concept] (/img/dartling_todos/task_concept.png)

**Figure 1**: Task concept.

There is also an internal identifier that is not shown to users. A task may be added and removed. It has two states: left (to be done) and completed. All left tasks may become completed. Completed tasked may be cleared (removed).

Recently, [Dart] (http://www.dartlang.org/) has been used by [Mathieu Lorber] (https://github.com/MathieuLorber/todomvc) to develop the todomvc application without a model framework.

I have adapted the todomvc application to [dartling] (https://github.com/dzenanr/dartling). The [dartling_todos] (https://github.com/dzenanr/dartling_todos) application has the standard TodoMVC presentation but with one difference -- a user may undo (and redo) his actions (Figure 2).

![Alt Figure 2: TodoMVC in Dart with dartling] (/img/dartling_todos/dartling_todos_app.png)

**Figure 2**: TodoMVC in Dart with dartling.

dartling is a domain model framework with a model generated from the [JSON] (http://www.json.org/) representation of a graphical model designed in [Magic Boxes] (https://github.com/dzenanr/magic_boxes). The generated model has actions, action pre and post validations, error handling, select data views, view update propagations, reaction events, transactions, sessions with the trans(action) past, so that undos and redos on the model may be done. In dartling, there may be multiple domains and multiple models within domains, which can be used together. There are five examples in the dartling project: Art.Pen, Game.Parking and three different models to show different types of relationships including reflexive relationships.

In the following posts I will explain how I developed the dartling_todos application in spirals, starting with the todomvc application of Mathieu Lorber, and progressing to the last spiral with actions, transactions, model events, undos and redos.
