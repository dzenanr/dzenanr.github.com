---
layout: default
title: Complete All Todos
comments: true
---

There are 10 spirals in the [todo_mvc_spirals] (https://github.com/dzenanr/todo_mvc_spirals) project: from todo_mvc_s00 to todo_mvc_s09. The final version is the [dartling_todos] (https://github.com/dzenanr/dartling_todos) application. This post is about todo_mvc_s05.

In the todo_mvc_s05 spiral, in the upper left corner of todos (Figure 1),

![Alt Figure 1: todo_mvc_s05] (/img/todo_mvc_s05/complete_all_todos.png)

**Figure 1**: Complete all todos.

there is a checkbox to complete all todos by clicking on its unusual display (Code 1). See #toggle-all-completed in the web/css/base.css file for a display different from a regular checkbox. The web/todo_mvc.html file is renamed to web/todos.html and web/todo_mvc.dart to web/todos.dart.

**Code 1**: main section in todos.html.

{% highlight html %}

    <section id="main">
      <input id="toggle-all-completed" type="checkbox">
      <ul id="todo-list"></ul>
    </section>

{% endhighlight %}

The lib/app/todo_app.dart file becomes lib/app/todos.dart. There is a new input element in the TodoApp class (Code 2).

**Code 2**: Input element.

{% highlight dart %}

class TodoApp {
  Tasks tasks;
  var todos = new List<Todo>();

  Element main = query('#main');
  InputElement allCompleted = query('#toggle-all-completed');

}

{% endhighlight %}

In the constructor of the TodoApp class, a click event is defined, where all not completed todos become complete or all completed todos become again left to do.

**Code 3**: Toggling todos.

{% highlight dart %}

    allCompleted.on.click.add((Event e) {
      InputElement target = e.currentTarget;
      for (Todo todo in todos) {
        if (todo.task.completed != target.checked) {
          todo.toggleCompleted();
        }
      }
      updateCounts();
    });

{% endhighlight %}

The updateCounts method of the TodoApp class (Code 4), renamed from updateTodoCount, reflects well the number of tasks left to do and the number of tasks completed (to be cleared by a click on the button).

**Code 4**: Update counts.

{% highlight dart %}

  updateCounts() {
    allCompleted.checked = (tasks.completed == tasks.count);
    todoCount.innerHTML =
        '<b>${tasks.left}</b> todo${tasks.left != 1 ? 's' : ''} left';
    if (tasks.completed == 0) {
          clearCompleted.style.display = 'none';
    } else {
      clearCompleted.style.display = 'block';
      clearCompleted.text = 'Clear completed (${tasks.completed})';
    }
    save();
  }

{% endhighlight %}

The createElement method in the Todo class is renamed to create (Code 5). Also, the CSS class of the input checkbox element for a single todo is renamed from toggle to toggle-completed (Code 5).

**Code 5**: Create element.

{% highlight dart %}

  Element create() {
    todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='toggle-completed' type='checkbox' 
            ${task.completed ? 'checked' : ''}>
          <label class='todo-content'>${task.title}</label>
          <button class='remove'></button>
        </div>
      </li>
    ''');

{% endhighlight %}

Finally, the toggleTodo method in the Todo class is renamed to toggleCompleted (Code 6). 

**Code 6**: Toggle completed.

{% highlight dart %}

  toggleCompleted() {
    task.completed = !task.completed;
    toggle.checked = task.completed;
    if (task.completed) {
      todo.classes.add('completed');
    } else {
      todo.classes.remove('completed');
    }
  }

{% endhighlight %}



