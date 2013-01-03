---
layout: default
title: Test Model
comments: true
---

There are 10 spirals in the [todo_mvc_spirals] (https://github.com/dzenanr/todo_mvc_spirals) project: from todo_mvc_s00 to todo_mvc_s09. The final version is the [dartling_todos] (https://github.com/dzenanr/dartling_todos) application. This post is about todo_mvc_s06.

In the todo_mvc_s06 spiral, a todo may be edited (Figure 1),

![Alt Figure 1: todo_mvc_s06] (/img/todo_mvc_s06/edit_a_todo.png)

**Figure 1**: Edit todo.

The TodoApp class is renamed to Todos (Code 1). 

**Code 1**: Todos class.

{% highlight dart %}

class Todos {
  Tasks tasks;
  var todos = new List<Todo>();

  Element main = query('#main');
  Element allCompleted = query('#toggle-all-completed');
  Element todoList = query('#todo-list');
  Element footer = query('#footer');
  Element leftCount = query('#left-count');
  Element clearCompleted = query('#clear-completed');

{% endhighlight %}

The create method in the Todo class has two elements that represent two different states of the todo element. The todoContent element is double-clicked to edit the task title in the edit element (Code 2). The double click event adds the editing CSS class to the todo element, then selects and focuses on the edit element. The key press event on the edit element calls the editingDone function when the ENTER key is used. The editingDone function updates the corresponding task title and the displayed value of the todoContent element. After the editing CSS class is removed from the todo element, todos are saved to the local storage.

**Code 2**: Todo content and edit elements.

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
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    Element todoContent = todo.query('.todo-content');
    Element edit = todo.query('.edit');

    todoContent.on.doubleClick.add((MouseEvent e) {
      todo.classes.add('editing');
      edit.select();
      edit.focus();
    });

    editingDone(event) {
      task.title = edit.value.trim();
      if (task.title != '') {
        todoContent.text = task.title;
        todo.classes.remove('editing');
        todos.save();
      }
    }

    edit.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        editingDone(e);
      }
    });

{% endhighlight %}

In the test/todo/mvc/todo_mvc_test.dart file there are 27 tests of the dartling model. When the file is run in Dart Editor all tests pass (Code 3).

**Code 3**: Passed tests.

{% highlight dart %}

PASS: Testing Todo.Mvc Empty Entries Test
PASS: Testing Todo.Mvc From Tasks to JSON
PASS: Testing Todo.Mvc From Task Model to JSON
PASS: Testing Todo.Mvc From JSON to Task Model
PASS: Testing Todo.Mvc Add Task Required Title Error
PASS: Testing Todo.Mvc Add Task Pre Validation
PASS: Testing Todo.Mvc Find Task by New Oid
PASS: Testing Todo.Mvc Find Task by Attribute
PASS: Testing Todo.Mvc Random Task
PASS: Testing Todo.Mvc Select Tasks by Function
PASS: Testing Todo.Mvc Select Tasks by Function then Add
PASS: Testing Todo.Mvc Select Tasks by Function then Remove
PASS: Testing Todo.Mvc Order Tasks by Title
PASS: Testing Todo.Mvc Copy Tasks
PASS: Testing Todo.Mvc Copy Equality
PASS: Testing Todo.Mvc True for Every Task
PASS: Testing Todo.Mvc Find Task then Set Oid with Failure
PASS: Testing Todo.Mvc Find Task then Set Oid with Success
PASS: Testing Todo.Mvc Update New Task Title with Failure
PASS: Testing Todo.Mvc Update New Task Oid with Success
PASS: Testing Todo.Mvc Find Task by Attribute then Examine Code and Id
PASS: Testing Todo.Mvc Add Task Undo and Redo
PASS: Testing Todo.Mvc Remove Task Undo and Redo
PASS: Testing Todo.Mvc Add Task Undo and Redo with Session
PASS: Testing Todo.Mvc Undo and Redo Update Task Title
PASS: Testing Todo.Mvc Undo and Redo Transaction
PASS: Testing Todo.Mvc Reactions to Task Actions

All 27 tests passed.
unittest-suite-success

{% endhighlight %}

There are 3 packages imported in the test file, the unittest package to use the testing facility, the dartling package to inherit methods on entities of the model, and the todo_mvc package to use the specific code added to the model (Code 4).

**Code 4**: Packages used in testing the model.

{% highlight dart %}

import "package:unittest/unittest.dart";
import "package:dartling/dartling.dart";
import "package:todo_mvc/todo_mvc.dart";

{% endhighlight %}

The Todo repository is created in the main function of the testing file and passed as an argument to the testTodoData function (Code 5).

**Code 5**: Start testing.

{% highlight dart %}

testTodoData(TodoRepo todoRepo) {
  testTodoMvc(todoRepo, TodoRepo.todoDomainCode,
      TodoRepo.todoMvcModelCode);
}

void main() {
  var todoRepo = new TodoRepo();
  testTodoData(todoRepo);
}

{% endhighlight %}

The testTodoData function finds the domain and model names and calls the testTodoMvc function (Code 6). In the setUp function (setup for each test), based on the domain name (code in dartling), a collection of models (in this example only one) of the domain are retrieved. A new session is defined. Based on the model name (code), entries (in this example only one -- tasks) of the model are obtained.

**Code 6**: Test the Mvc model in the Todo domain.

{% highlight dart %}

testTodoMvc(Repo repo, String domainCode, String modelCode) {
  TodoModels models;
  DomainSession session;
  MvcEntries entries;
  Tasks tasks;
  int count = 0;
  Concept concept;
  group("Testing ${domainCode}.${modelCode}", () {
    setUp(() {
      models = repo.getDomainModels(domainCode);
      session = models.newSession();
      entries = models.getModelEntries(modelCode);
      expect(entries, isNotNull);
      tasks = entries.tasks;
      expect(tasks.count, equals(count));
      concept = tasks.concept;
      expect(concept, isNotNull);
      expect(concept.attributes.list, isNot(isEmpty));

{% endhighlight %}

Three tasks are created in the setup for each test (Code 7).

**Code 7**: Each test starts with 3 tasks.

{% highlight dart %}

      var design = new Task(concept);
      expect(design, isNotNull);
      design.title = 'design a model';
      tasks.add(design);
      expect(tasks.count, equals(++count));

      var json = new Task(concept);
      json.title = 'generate json from the model';
      tasks.add(json);
      expect(tasks.count, equals(++count));

      var generate = new Task(concept);
      generate.title = 'generate code from the json document';
      tasks.add(generate);
      expect(tasks.count, equals(++count));

{% endhighlight %}

The tearDown function is called after each test to clear all tasks (Code 8). The setUp function is called before every test to create several tasks.

**Code 8**: After every test tasks are cleared.

{% highlight dart %}

    tearDown(() {
      tasks.clear();
      expect(tasks.empty, isTrue);
      count = 0;
    });

{% endhighlight %}

The first test clears all entries (Code 9). Since there is only one entry to the model, which is tasks, the tasks are cleared and entries become empty. This means that the model does not have any data.

**Code 9**: Empty model.

{% highlight dart %}

    test('Empty Entries Test', () {
      entries.clear();
      expect(entries.empty, isTrue);
    });

{% endhighlight %}

The three tasks created in the setUp function are transformed by dartling into a list of maps, a map for each task,, then printed (Code 10).

**Code 10**: From tasks to a list of maps.

{% highlight dart %}

    test('From Tasks to JSON', () {
      var json = tasks.toJson();
      expect(json, isNotNull);
      print(json);
    });

{% endhighlight %}

The printed list displayed in the Console of Dart Editor (Code 11).

**Code 11**: List of maps.

{% highlight dart %}

[
   {
      completed:false,
      oid:1357225270729,
      title:design a model,
      code:null
   },
   {
      completed:false,
      oid:1357225270731,
      title:generate json from the model,
      code:null
   },
   {
      completed:false,
      oid:1357225270732,
      title:generate code from the json document,
      code:null
   }
]

{% endhighlight %}

The model of tasks is transformed into the JSON representation, then displayed in the Console of Dart Editor (Code 12).

**Code 12**: From model to JSON.

{% highlight dart %}

    test('From Task Model to JSON', () {
      var json = entries.toJson();
      expect(json, isNotNull);
      entries.displayJson();
    });

{% endhighlight %}

The JSON text is displayed in the Console of Dart Editor (Code 13).

**Code 13**: Model in JSON.

{% highlight json %}

{
   "domain":"Todo",
   "entries":[
      {
         "concept":"Task",
         "entities":[
            {
               "completed":"false",
               "oid":"1357225270740",
               "title":"design a model",
               "code":null
            },
            {
               "completed":"false",
               "oid":"1357225270741",
               "title":"generate json from the model",
               "code":null
            },
            {
               "completed":"false",
               "oid":"1357225270742",
               "title":"generate code from the json document",
               "code":null
            }
         ]
      }
   ],
   "model":"Mvc"
}

{% endhighlight %}

The JSON representation is transformed back to the model, then displayed (Code 14).

**Code 14**: From JSON to model.

{% highlight dart %}

    test('From JSON to Task Model', () {
      tasks.clear();
      expect(tasks.empty, isTrue);
      entries.fromJsonToData();
      expect(tasks.empty, isFalse);
      tasks.display(title:'From JSON to Task Model');
    });

{% endhighlight %}

The tasks are displayed in the Console of Dart Editor (Code 15).

**Code 15**: Displayed model.

{% highlight dart %}

======================================
From JSON to Task Model                                
======================================
------------------------------------
{Task: {oid:1353105264405}}                       
------------------------------------
  oid: 1353105264405
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1353105264407}}                       
------------------------------------
  oid: 1353105264407
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1353105264408}}                       
------------------------------------
  oid: 1353105264408
  title: generate code from the json document
  completed: false

{% endhighlight %}

A new task is created but without a title (Code 16). The add method of the tasks object was not able to complete the action. This validation is done by dartling based on the definition of the model.

**Code 16**: Required title test.

{% highlight dart %}

    test('Add Task Required Title Error', () {
      var task = new Task(concept);
      expect(concept, isNotNull);
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.count, equals(count));
      expect(tasks.errors.count, equals(1));
      expect(tasks.errors.list[0].category, equals('required'));
      tasks.errors.display(title:'Add Task Required Title Error');
    });

{% endhighlight %}

The required attribute error is displayed in Code 17.

**Code 17**: Required title error.

{% highlight dart %}

************************************************
Add Task Required Title Error                                          
************************************************

*** ******************************************
*** required                               
*** ******************************************
*** message: Task.title attribute is null.
*** ******************************************

{% endhighlight %}

A new task with a title longer than 64 characters could not be added (Code 18). 

**Code 18**: Pre add validation test.

{% highlight dart %}

    test('Add Task Pre Validation', () {
      var task = new Task(concept);
      task.title =
        'A new todo task with a long title that cannot be accepted if it is '
        'longer than 64 characters';
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.count, equals(count));
      expect(tasks.errors, hasLength(1));
      expect(tasks.errors.list[0].category, equals('pre'));
      tasks.errors.display(title:'Add Task Pre Validation');
    });

{% endhighlight %}

This is a specific validation added by hand to the Tasks class in the lib/todo/mvc folder (Code 19).

**Code 19**: Pre add validation.

{% highlight dart %}

  bool preAdd(Task task) {
    bool validation = super.preAdd(task);
    if (validation) {
      validation = task.title.length <= 64;
      if (!validation) {
        var error = new ValidationError('pre');
        error.message =
            '${concept.codePlural}.preAdd rejects the "${task.title}" '
            'title that is longer than 64.';
        errors.add(error);
      }
    }
    return validation;
  }

{% endhighlight %}

The pre add specific validation error is displayed in Code 20.

**Code 20**: Pre add validation error.

{% highlight dart %}

************************************************
Add Task Pre Validation                                          
************************************************

*** ******************************************
*** pre                               
*** ******************************************
*** message: Tasks.preAdd rejects the "A new todo task with a long title that cannot be accepted if it is longer than 64 characters" title that is longer than 64.
*** ******************************************

{% endhighlight %}

A new oid time stamp is created and a task with that value is searched. Since there is no task with that value, the find method returns null.

**Code 21**: Not found task.

{% highlight dart %}

    test('Find Task by New Oid', () {
      var oid = new Oid.ts(1345648254063);
      var task = tasks.find(oid);
      expect(task, isNull);
    });

{% endhighlight %}

There is a task with the given title (Code 22).

**Code 22**: Found task.

{% highlight dart %}

    test('Find Task by Attribute', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
    });

{% endhighlight %}

A random task may be retrieved from its collection of entities by the random method (Code 23).

**Code 23**: Random tasks.

{% highlight dart %}

    test('Random Task', () {
      var task1 = tasks.random();
      expect(task1, isNotNull);
      task1.display(prefix:'random 1');
      var task2 = tasks.random();
      expect(task2, isNotNull);
      task2.display(prefix:'random 2');
    });

{% endhighlight %}

The two random task are displayed in Code 23.

**Code 24**: Displayed random tasks.

{% highlight dart %}

random 1------------------------------------
random 1{Task: {oid:1357225270804}}                       
random 1------------------------------------
random 1  oid: 1357225270804
random 1  title: design a model
random 1  completed: false

random 2------------------------------------
random 2{Task: {oid:1357225270807}}                       
random 2------------------------------------
random 2  oid: 1357225270807
random 2  title: generate code from the json document
random 2  completed: false

{% endhighlight %}

There are 2 tasks with the generate word in their titles (Code 25).

**Code 25**: Selection by function.

{% highlight dart %}

    test('Select Tasks by Function', () {
      Tasks generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.length, equals(2));

      generateTasks.display(title:'Select Tasks by Function');
    });

{% endhighlight %}

The select method of dartling accepts a boolean function. The generate property is defined by hand in the specific Task class in the lib/todo/mvc folder (Code 26).

**Code 26**: Specific property.

{% highlight dart %}

    bool get generate => title.contains('generate') ? true : false;

{% endhighlight %}

The selected tasks are displayed in Code 27.

**Code 27**: Selected tasks.

{% highlight dart %}

======================================
Select Tasks by Function                                
======================================
------------------------------------
{Task: {oid:1357225270813}}                       
------------------------------------
  oid: 1357225270813
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357225270814}}                       
------------------------------------
  oid: 1357225270814
  title: generate code from the json document
  completed: false

{% endhighlight %}

Tasks that have generate in their titles are selected, then a new task is added to the selection (Code 28).

**Code 28**: Add propagation from the selection destination to the selection source.

{% highlight dart %}

    test('Select Tasks by Function then Add', () {
      var generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.source.empty, isFalse);

      var programmingTask = new Task(concept);
      programmingTask.title = 'dartling programming';
      var added = generateTasks.add(programmingTask);
      expect(added, isTrue);

      generateTasks.display(title:'Select Tasks by Function then Add');
      tasks.display(title:'All Tasks');
    });

{% endhighlight %}

The selected tasks with the added task are displayed. Then, all tasks are displayed to show that the added task is propagated to the source of selection (Code 29).

**Code 29**: Selected tasks with the add propagation.

{% highlight dart %}

======================================
Select Tasks by Function then Add                                
======================================
------------------------------------
{Task: {oid:1357225270821}}                       
------------------------------------
  oid: 1357225270821
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357225270822}}                       
------------------------------------
  oid: 1357225270822
  title: generate code from the json document
  completed: false

------------------------------------
{Task: {oid:1357225270824}}                       
------------------------------------
  oid: 1357225270824
  title: dartling programming
  completed: false

======================================
All Tasks                                
======================================
------------------------------------
{Task: {oid:1357225270820}}                       
------------------------------------
  oid: 1357225270820
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357225270821}}                       
------------------------------------
  oid: 1357225270821
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357225270822}}                       
------------------------------------
  oid: 1357225270822
  title: generate code from the json document
  completed: false

------------------------------------
{Task: {oid:1357225270824}}                       
------------------------------------
  oid: 1357225270824
  title: dartling programming
  completed: false

{% endhighlight %}

A task is removed from the selection (destination). This removal is then propagated to the selection source.

**Code 30**: Select then remove.

{% highlight dart %}

    test('Select Tasks by Function then Remove', () {
      var generateTasks = tasks.select((task) => task.generate);
      expect(generateTasks.empty, isFalse);
      expect(generateTasks.source.empty, isFalse);

      var title = 'generate json from the model';
      var task = generateTasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
      var generateCount = generateTasks.count;
      generateTasks.remove(task);
      expect(generateTasks.count, equals(--generateCount));
      expect(tasks.count, equals(--count));
    });

{% endhighlight %}

Tasks are ordered by title in Code 31.

**Code 31**: Order tasks by title.

{% highlight dart %}

    test('Order Tasks by Title', () {
      Tasks orderedTasks = tasks.order();
      expect(orderedTasks.empty, isFalse);
      expect(orderedTasks.count, equals(tasks.count));
      expect(orderedTasks.source.empty, isFalse);
      expect(orderedTasks.source.count, equals(tasks.count));

      orderedTasks.display(title:'Order Tasks by Title');
    });

{% endhighlight %}

Ordered tasks are displayed in Code 32.

**Code 32**: Ordered tasks.

{% highlight dart %}

======================================
Order Tasks by Title                                
======================================
------------------------------------
{Task: {oid:1357225270843}}                       
------------------------------------
  oid: 1357225270843
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357225270846}}                       
------------------------------------
  oid: 1357225270846
  title: generate code from the json document
  completed: false

------------------------------------
{Task: {oid:1357225270845}}                       
------------------------------------
  oid: 1357225270845
  title: generate json from the model
  completed: false

{% endhighlight %}

Tasks are copied in Code 33.

**Code 33**: Copy tasks.

{% highlight dart %}

    test('Copy Tasks', () {
      Tasks copiedTasks = tasks.copy();
      expect(copiedTasks.empty, isFalse);
      expect(copiedTasks.count, equals(tasks.count));
      expect(copiedTasks, isNot(same(tasks)));
      expect(copiedTasks, equals(tasks));
      copiedTasks.forEach((ct) =>
          expect(ct, isNot(same(tasks.findByAttribute('title', ct.title)))));
      copiedTasks.display(title:'Copied Tasks');
    });

{% endhighlight %}

Copied tasks are displayed in Code 34.

**Code 34**: Copied tasks.

{% highlight dart %}

======================================
Copied Tasks                                
======================================
------------------------------------
{Task: {oid:1357225270853}}                       
------------------------------------
  oid: 1357225270853
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357225270854}}                       
------------------------------------
  oid: 1357225270854
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357225270855}}                       
------------------------------------
  oid: 1357225270855
  title: generate code from the json document
  completed: false

{% endhighlight %}

A task is copied in Code 35. 

**Code 35**: Copy a task.

{% highlight dart %}

    test('Copy Equality', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      task.display(prefix:'before copy: ');
      var copiedTask = task.copy();
      copiedTask.display(prefix:'after copy: ');
      expect(task, isNot(same(copiedTask)));
      expect(task, equals(copiedTask));
      expect(task.oid, equals(copiedTask.oid));
      expect(task.code, equals(copiedTask.code));
      expect(task.title, equals(copiedTask.title));
      expect(task.completed, equals(copiedTask.completed));
    });

{% endhighlight %}

Although the two tasks have the same content, they are two different objects (Code 36).

**Code 36**: Copy source task and copy destination task.

{% highlight dart %}

before copy: ------------------------------------
before copy: {Task: {oid:1357231901837}}                       
before copy: ------------------------------------
before copy:   oid: 1357231901837
before copy:   title: writing a tutorial on Dartling
before copy:   completed: false

after copy: ------------------------------------
after copy: {Task: {oid:1357231901837}}                       
after copy: ------------------------------------
after copy:   oid: 1357231901837
after copy:   title: writing a tutorial on Dartling
after copy:   completed: false

{% endhighlight %}

It is true for every task that the code attribute inherited from dartling is null and that the title attribute is not null (Code 37).

**Code 37**: True for every task.

{% highlight dart %}

    test('True for Every Task', () {
      expect(tasks.every((t) => t.code == null), isTrue);
      expect(tasks.every((t) => t.title != null), isTrue);
    });

{% endhighlight %}

In dartling, an oid cannot be set by default (Code 38).

**Code 38**: Cannot set oid.

{% highlight dart %}

    test('Find Task then Set Oid with Failure', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(() => task.oid = new Oid.ts(1345648254063), throws);
    });

{% endhighlight %}

However, an oid can be set with the help of meta handling (Code 39).

**Code 39**: Set oid.

{% highlight dart %}

    test('Find Task then Set Oid with Success', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      task.display(prefix:'before oid set: ');
      task.concept.updateOid = true;
      task.oid = new Oid.ts(1345648254063);
      task.concept.updateOid = false;
      task.display(prefix:'after oid set: ');
    });

{% endhighlight %}

The same task with two different oids is displayed in Code 40.

**Code 40**: Task with changed oid.

{% highlight dart %}

before oid set: ------------------------------------
before oid set: {Task: {oid:1357233715681}}                       
before oid set: ------------------------------------
before oid set:   oid: 1357233715681
before oid set:   title: generate json from the model
before oid set:   completed: false

after oid set: ------------------------------------
after oid set: {Task: {oid:1345648254063}}                       
after oid set: ------------------------------------
after oid set:   oid: 1345648254063
after oid set:   title: generate json from the model
after oid set:   completed: false


{% endhighlight %}

An attribute cannot be set by the update method (Code 41).

**Code 41**: Update a task title error.

{% highlight dart %}

    test('Update New Task Title with Failure', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      var copiedTask = task.copy();
      copiedTask.title = 'writing a paper on Dartling';
      // Entities.update can only be used if oid, code or id set.
      expect(() => tasks.update(task, copiedTask), throws);
    });

{% endhighlight %}

However, a task oid can be set by the update method (Code 42). Note that the update method removes the entity before the update and adds the entity with a new oid. This is done in order to update a map of oids in dartling, so that an entity may be found quickly based on its oid. 

**Code 42**: Update a task oid.

{% highlight dart %}

    test('Update New Project Oid with Success', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.count, equals(++count));

      var copiedTask = task.copy();
      copiedTask.concept.updateOid = true;
      copiedTask.oid = new Oid.ts(1345648254063);
      copiedTask.concept.updateOid = false;
      // Entities.update can only be used if oid, code or id set.
      tasks.update(task, copiedTask);
      var foundTask = tasks.findByAttribute('title', task.title);
      expect(foundTask, isNotNull);
      expect(foundTask.oid, equals(copiedTask.oid));
      // Entities.update removes the before update entity and
      // adds the after update entity,
      // in order to update oid, code and id entity maps.
      expect(task.oid, isNot(equals(copiedTask.oid)));
    });

{% endhighlight %}

The same reasoning applies to the code attribute that is inherited by all entities in dartling. If used, the code attribute must be a unique String. In this model, the code attribute is not used (Code 43). There is no id in the Task concept (Code 43). In general, the update reasoning applies to the id of a concept.

**Code 43**: Code and id are null.

{% highlight dart %}

    test('Find Task by Attribute then Examine Code and Id', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.code, isNull);
      expect(task.id, isNull);
    });

{% endhighlight %}

The add action may be done, undone, and redone again (Code 44).

**Code 44**: Undo and redo an add action.

{% highlight dart %}

    test('Add Task Undo and Redo', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';

      var action = new AddAction(session, tasks, task);
      action.doit();
      expect(tasks.count, equals(++count));

      action.undo();
      expect(tasks.count, equals(--count));

      action.redo();
      expect(tasks.count, equals(++count));
    });

{% endhighlight %}

The remove action may be done, undone, and redone again (Code 45).

**Code 45**: Undo and redo a remove action.

{% highlight dart %}

    test('Remove Task Undo and Redo', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);

      var action = new RemoveAction(session, tasks, task);
      action.doit();
      expect(tasks.count, equals(--count));

      action.undo();
      expect(tasks.count, equals(++count));

      action.redo();
      expect(tasks.count, equals(--count));
    });

{% endhighlight %}

An action may be undone and redone with session past (or history) methods (Code 46).

**Code 46**: Undo and redo with session.

{% highlight dart %}

    test('Add Task Undo and Redo with Session', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';

      var action = new AddAction(session, tasks, task);
      action.doit();
      expect(tasks.count, equals(++count));

      session.past.undo();
      expect(tasks.count, equals(--count));

      session.past.redo();
      expect(tasks.count, equals(++count));
    });

{% endhighlight %}

The set attribute action may be done, undone, and redone (Code 47).

**Code 47**: Undo and redo the set attribute action.

{% highlight dart %}

    test('Undo and Redo Update Task Title', () {
      var title = 'generate json from the model';
      var task = tasks.findByAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));

      var action =
          new SetAttributeAction(session, task, 'title',
              'generate from model to json');
      action.doit();

      session.past.undo();
      expect(task.title, equals(action.before));

      session.past.redo();
      expect(task.title, equals(action.after));
    });

{% endhighlight %}

A transaction with multiple actions may be done, undone (all actions) and redone (Code 48).

**Code 48**: Transaction.

{% highlight dart %}

    test('Undo and Redo Transaction', () {
      var task1 = new Task(concept);
      task1.title = 'data modeling';
      var action1 = new AddAction(session, tasks, task1);

      var task2 = new Task(concept);
      task2.title = 'database design';
      var action2 = new AddAction(session, tasks, task2);

      var transaction = new Transaction('two adds on tasks', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doit();
      count = count + 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Done');

      session.past.undo();
      count = count - 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Undone');

      session.past.redo();
      count = count + 2;
      expect(tasks.count, equals(count));
      tasks.display(title:'Transaction Redone');
    });

{% endhighlight %}

Two tasks are added by a single transaction (Code 49). The transaction is then undone (two tasks removed) and redone again (two tasks added).

**Code 49**: Displayed tasks for the done, undone and redone transaction.

{% highlight dart %}

======================================
Transaction Done                                
======================================
------------------------------------
{Task: {oid:1357237710176}}                       
------------------------------------
  oid: 1357237710176
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357237710177}}                       
------------------------------------
  oid: 1357237710177
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357237710178}}                       
------------------------------------
  oid: 1357237710178
  title: generate code from the json document
  completed: false

------------------------------------
{Task: {oid:1357237710180}}                       
------------------------------------
  oid: 1357237710180
  title: data modeling
  completed: false

------------------------------------
{Task: {oid:1357237710181}}                       
------------------------------------
  oid: 1357237710181
  title: database design
  completed: false

======================================
Transaction Undone                                
======================================
------------------------------------
{Task: {oid:1357237710176}}                       
------------------------------------
  oid: 1357237710176
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357237710177}}                       
------------------------------------
  oid: 1357237710177
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357237710178}}                       
------------------------------------
  oid: 1357237710178
  title: generate code from the json document
  completed: false

======================================
Transaction Redone                                
======================================
------------------------------------
{Task: {oid:1357237710176}}                       
------------------------------------
  oid: 1357237710176
  title: design a model
  completed: false

------------------------------------
{Task: {oid:1357237710177}}                       
------------------------------------
  oid: 1357237710177
  title: generate json from the model
  completed: false

------------------------------------
{Task: {oid:1357237710178}}                       
------------------------------------
  oid: 1357237710178
  title: generate code from the json document
  completed: false

------------------------------------
{Task: {oid:1357237710180}}                       
------------------------------------
  oid: 1357237710180
  title: data modeling
  completed: false

------------------------------------
{Task: {oid:1357237710181}}                       
------------------------------------
  oid: 1357237710181
  title: database design
  completed: false

{% endhighlight %}

In dartling, reactions to actions (Code 50) and transactions may be defined (Code 51).

**Code 50**: Task actions.

{% highlight dart %}

    test('Reactions to Task Actions', () {
      var reaction = new Reaction();
      expect(reaction, isNotNull);

      models.startActionReaction(reaction);
      var task = new Task(concept);
      task.title = 'validate dartling documentation';

      var session = models.newSession();
      var addAction = new AddAction(session, tasks, task);
      addAction.doit();
      expect(tasks.count, equals(++count));
      expect(reaction.reactedOnAdd, isTrue);

      var title = 'documenting dartling';
      var setAttributeAction =
          new SetAttributeAction(session, task, 'title', title);
      setAttributeAction.doit();
      expect(reaction.reactedOnUpdate, isTrue);
      models.cancelActionReaction(reaction);
    });

{% endhighlight %}

The Reaction class (Code 51), which must implement the ActionReactionApi abstract class of dartling, is declared in the todo_mvc_test file.

**Code 51**: Reaction to task actions.

{% highlight dart %}

class Reaction implements ActionReactionApi {

  bool reactedOnAdd = false;
  bool reactedOnUpdate = false;

  react(BasicAction action) {
    if (action is EntitiesAction) {
      reactedOnAdd = true;
    } else if (action is EntityAction) {
      reactedOnUpdate = true;
    }
  }

}

{% endhighlight %}





