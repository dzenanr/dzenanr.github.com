---
layout: default
title: Tasks Left Todo
comments: true
---

There are 10 spirals in the [todo_mvc_spirals] (https://github.com/dzenanr/todo_mvc_spirals) project: from todo_mvc_s00 to todo_mvc_s09. The final version is the [dartling_todos] (https://github.com/dzenanr/dartling_todos) application. This post is about todo_mvc_s02.

In the todo_mvc_s02 spiral, there is a footer (Figure 1), 

![Alt Figure 1: todo_mvc_s02] (/img/todo_mvc_s02/tasks_left_todo.png)

**Figure 1**: Tasks left to do.

with a count of items left to do (Code 1).

**Code 1**: Footer in web/todo_mvc.html.

{% highlight html %}

    <footer id="footer">
      <span id="todo-count"><strong>0</strong> item left</span>
    </footer>

{% endhighlight %}

There is a change in the lib/todo/mvc/tasks.dart file. There are two new properties (methods) in the Tasks class (Code 2). A subset of entities (here tasks) may be obtained in dartling by using an anonymous, boolean function as the argument of the select method.

**Code 2**: Properties.

{% highlight dart %}

  int get completed => select((task) => task.completed).count;
  int get left => count - completed;

{% endhighlight %}

There are two new elements in the TodoApp class (Code 3) located in the lib/app/todo_app.dart file. One element is identified by the footer id and the other by the todo-count id from Code 1.

**Code 3**: Elements.

{% highlight dart %}

class TodoApp {
  Tasks tasks;
  var todoWidgets = new List<TodoWidget>();
  Element todoListElement = query('#todo-list');
  Element footerElement = query('#footer');
  Element countElement = query('#todo-count');

}

{% endhighlight %}

When a new task is added, the updateFooterDisplay method (Code 4) is called to prepare the style display value and to update the count of tasks left to be done.

**Code 4**: Methods in the TodoApp class.

{% highlight dart %}

  void updateFooterDisplay() {
    var display = todoWidgets.length == 0 ? 'none' : 'block';
    footerElement.style.display = display;
    updateCount();
  }

  void updateCount() {
    countElement.innerHTML =
        '<b>${tasks.left}</b> item${tasks.left != 1 ? 's' : ''} left';
  }

{% endhighlight %}

When a task is completed, the number of tasks to do changes. In the TodoWidget class, located in the lib/app/todo_widget.dart file, a reaction to the click event on the toggle element includes now a call (Code 5) to the updateCount method of the TodoApp class.

**Code 5**: Update count.

{% highlight dart %}

    toggleElement.on.click.add((MouseEvent e) {
      toggle();
      todoApp.updateCount();
    });

{% endhighlight %}

To be able to call the updateCount method, the application object is passed to the constructor of the TodoWidget class (Code 6).

**Code 6**: Application parameter.

{% highlight dart %}

class TodoWidget {
  Task task;
  TodoApp todoApp;
  Element element;
  Element toggleElement;

  TodoWidget(this.task, this.todoApp);

{% endhighlight %}

