---
layout: default
title: Clear Completed Tasks
comments: true
---

There are 10 spirals in the [todo_mvc_spirals] (https://github.com/dzenanr/todo_mvc_spirals) project: from todo_mvc_s00 to todo_mvc_s09. The final version is the [dartling_todos] (https://github.com/dzenanr/dartling_todos) application. This post is about todo_mvc_s03.

In the todo_mvc_s03 spiral, there is a button (Figure 1), 

![Alt Figure 1: todo_mvc_s03] (/img/todo_mvc_s03/clear_completed_tasks.png)

**Figure 1**: Clear completed tasks.

which clears the completed tasks (Code 1).

**Code 1**: Clear completed button in web/todo_mvc.html.

{% highlight html %}

      <button id="clear-completed">Clear completed</button>

{% endhighlight %}

In addition, a single task completed or left to do, may be removed by clicking on the x icon at the far right end of a task.

There is a new element in the TodoApp class located in the lib/app/todo_app.dart file (Code 2).

**Code 2**: Clear completed element.

{% highlight dart %}

class TodoApp {
  Tasks tasks;
  var todoWidgets = new List<TodoWidget>();
  Element todoListElement = query('#todo-list');
  Element footerElement = query('#footer');
  Element countElement = query('#todo-count');
  Element clearCompletedElement = query('#clear-completed');

}

{% endhighlight %}

A click on the Clear completed button triggers a traversal of todo widgets (Code 3). If a todo widget is completed it is removed.

**Code 3**: Button click event.

{% highlight dart %}

    clearCompletedElement.on.click.add((MouseEvent e) {
      var newList = new List<TodoWidget>();
      for (TodoWidget todoWidget in todoWidgets) {
        if (todoWidget.task.completed) {
          todoWidget.element.remove();
        } else {
          newList.add(todoWidget);
        }
      }
      todoWidgets = newList;
      updateFooterDisplay();
    });

{% endhighlight %}

A single task completed or not, may be removed by clicking on the x icon at the far right end of a task. A button with the destroy CSS class is added to the createElement method of the TodoWidget class (Code 4).

**Code 4**: Destroy button.

{% highlight dart %}

  Element createElement() {
    element = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          
          <button class='destroy'></button>
        </div>
      </li>
    ''');

  }

{% endhighlight %}

The button with the destroy CSS class is queried (Code 5) in the createElement method (Code 4). The click event removes the element and calls two methods of the todo application.

**Code 5**: Remove element.

{% highlight dart %}

    removeTodo() {
      element.remove();
      todoApp.removeTodo(this);
      todoApp.updateFooterDisplay();
    }

    element.query('.destroy').on.click.add((MouseEvent e) {
      removeTodo();
    });

{% endhighlight %}

Based on the given todo widget, in the removeTodo method of the TodoApp class, the corresponding task is removed from the model and the list of widgets is updated (Code 6).

**Code 6**: Remove task.

{% highlight dart %}

  removeTodo(TodoWidget todoWidget) {
    var task = todoWidget.task;
    tasks.remove(task);
    todoWidgets.removeAt(todoWidgets.indexOf(todoWidget));
  }

{% endhighlight %}

