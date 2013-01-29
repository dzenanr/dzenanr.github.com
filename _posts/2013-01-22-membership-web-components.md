---
layout: default
title: Membership Web Components
comments: true
---

I have created a simple [membership application] (https://github.com/dzenanr/membership) to explore web components in the [Web UI] (http://www.dartlang.org/articles/dart-web-components/) package of Dart.

Developing web applications with web components is a new approach that will let us divide a page in sections and use a web component for each section. If web components become reusable in different contexts, we may have a catalog of web components that would allow us to select and reuse them in a few lines of code.

A web component has two files, one with the html code and the other with the Dart code. The Dart file is referenced by the src attribute of the script tag in the html file. When both files have the same name, it is easier to see them as parts of the same web component. In the html code, the structure of the web component is outlined. In addition, the presentation style for the component may be added. In the Dart code, a class that extends the WebComponent class of the Web UI package is defined, with its properties and methods that may be accessed in the corresponding html code.

A web component may be created by composing it from other web components. A web component may inherit data and operations from an existing component. One web component may pass its data to another component used in its composition (decomposition). A web component may access an already instantiated component. All of these possibilities are present in the single page membership application, although the application is rather simple.

The membership application has only one concept in its model -- Member, with five properties -- code, password, firstName, lastName, admin (Code 1).

**Code 1**: Member concept.

{% highlight dart %}

class Member {
  String code;
  String password = '';
  String firstName;
  String lastName;
  bool admin = false;

  Member(this.code);

} 

{% endhighlight %}

The Member class is placed in the members.dart file that is located in the lib/model folder. In addition to the lib folder, there is the web folder that contains the application page in html, membership_web.html, with its corresponding Dart code, membership_web.dart. All web components are also placed in the web folder, under the component folder. All member related components are grouped in the member folder of the component folder. In future, web components will be moved to the lib folder, in order to provide a better reusability of the components.

The application html file is used in the build.dart script file (Code 2) to generate by Dart Editor the code for all web components. The code is generated automatically and dynamically in the web/out folder. At the beginning of the learning process, you may ignore the content of the out folder. The script file is placed in the root folder of the membership application.

**Code 2**: Build script.

{% highlight dart %}

import 'package:web_ui/component_build.dart';
import 'dart:io';

void main() {
  build(new Options().arguments, ['web/membership_web.html']);
}

{% endhighlight %}

The application page uses the member-sign-in-list component (Code 3). A name of a web component must start with x- in order to avoid potential name conflicts within the page. The component is placed in the member_sign_in_list.html file that is located in the component/member subfolder of the web folder (see link rel="components" in Code 3).

**Code 3**: Application page: membership_web.html.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Membership</title>
    <link rel="components" href="component/member/member_sign_in_list.html">
    <link rel="stylesheet" href="css/page.css"/>
  </head>
  <body>
    <h1>Membership</h1>

    <x-member-sign-in-list members="{{ members }}"></x-member-sign-in-list>

    <script type="application/dart" src="membership_web.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>

{% endhighlight %}

The application Dart file (see script type="application/dart" in Code 3) has the main function, where two members are created (Code 4). The members property (Code 4) is passed as the {{ members }} expression to the members property of the member-sign-in-list component (Code 3).

**Code 4**: Application page: membership_web.dart.

{% highlight dart %}

import 'package:membership/membership.dart';

Members members;

main() {
  members = new Members();
  var administrator = new Member('dr');
  administrator.password = 'dr';
  administrator.firstName = 'Dzenan';
  administrator.lastName = 'Ridjanovic';
  administrator.admin = true;
  members.add(administrator);

  var member = new Member('acr');
  member.password = 'acr';
  member.firstName = 'Amra';
  member.lastName = 'Curovac Ridjanovic';
  members.add(member);

  members.order();
}

{% endhighlight %}

Although there are two members, the page does not does display them unless a member is signed in (Figure 1).

![Alt Figure 1: membership] (/img/membership/sign_in.png)

**Figure 1**: Sign in.

The member-sign-in-list web component uses three other components: member-sign-in, member-update-by-admin and member-list (Code 5). The component is defined within the element tag. It extends the span tag (the div and section tags are also good candidates for inheritance). Its markup is defined within the template tag.

**Code 5**: member-sign-in-list component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Sign In List</title>
    <link rel="components" href="member_sign_in.html">
    <link rel="components" href="member_update_by_admin.html">
    <link rel="components" href="member_list.html">
  </head>
  <body>
    <element name="x-member-sign-in-list" extends="span">
      <template>
        <x-member-sign-in members="{{ members }}"></x-member-sign-in>
        <div template if="adminSignedIn">
          <x-member-update-by-admin members="{{ members }}">
          </x-member-update-by-admin>
        </div>
        <div template if="memberSignedIn">
          <x-member-list members="{{ members }}"></x-member-list>
        </div>
      </template>
      <script type="application/dart" src="member_sign_in_list.dart"></script>
    </element>
  </body>
</html>

{% endhighlight %}

The component is composed of the member-sign-in component and conditionally of two other components. If an administrator is signed in, the member-update-by-admin component is instantiated. If a member is signed in, the member-list component is instantiated. The code in the member-sign-in-list.dart file handles those conditions (Code 6). Note that the class name is derived from the component's name by using the CamelCase.

**Code 6**: MemberSignInList component class.

{% highlight dart %}

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberSignInList extends WebComponent {
  Members members;

  bool get adminSignedIn {
    var signInComponent = document.query('x-member-sign-in').xtag;
    Member member = signInComponent.signedInMember;
    if (member != null && member.admin) {
      return true;
    }
    return false;
  }

  bool get memberSignedIn {
    var signInComponent = document.query('x-member-sign-in').xtag;
    Member member = signInComponent.signedInMember;
    if (member != null && !member.admin) {
      return true;
    }
    return false;
  }
}

{% endhighlight %}

A previously instantiated component may be retrieved by the xtag. Then, its properties may be accessed to make certain decisions. Here, a signed in member is either an admin or a member. If the signed in member is not an administrator, only the list of members is displayed by the member-list component (Figure 2).

![Alt Figure 2: membership] (/img/membership/sign_in_list.png)

**Figure 2**: Member signed in.

The member-list component iterates over all members (Code 7) and displays the result of the toString method of the Member class. The CSS style specific to the component is defined in the style tag.

**Code 7**: member-list component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member List</title>
  </head>
  <body>
    <element name="x-member-list" extends="span">
      <template>
        <div>
          <ul>
            <template iterate="member in members.toList()">
              <li>
                {{ member.toString() }}
              </li>
            </template>
          </ul>
        </div>
        <style>
          ul {
            font-size: 16px;
          }
        </style>
      </template>
      <script type="application/dart" src="member_list.dart"></script>
    </element>
  </body>
</html>

{% endhighlight %}

The member-list component does not have a specific behavior and its corresponding Dart code is simple with the members property only (Code 8).

**Code 8**: MemberList component class.

{% highlight dart %}

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberList extends WebComponent {
  Members members;
}

{% endhighlight %}

The member-sign-in component is rather complex because it uses several conditions (Code 9). If a user clicks on the Sign Up button (Figure 1) two additional fields appear. After a sign in, a member may access his personal data by clicking on a button with its sign in code. The personal data are handled by the member-update component.

**Code 9**: member-sign-in component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Sign In</title>
    <link rel="components" href="member_update.html">
  </head>
  <body>
    <element name="x-member-sign-in" extends="span">
      <template>
        <div template if="showSignIn">
          <label for="code">Code</label>
          <input id="code" type="text"/>
          <label for="password">Password</label>
          <input id="password" type="password"/>
          <br/>
          <div template if="showSignUp">
            <label for="firstName">First Name</label>
            <input id="firstName" type="text"/>
            <label for="lastName">Last Name</label>
            <input id="lastName" type="text"/>
            <br/>
            <button on-click="add()">Add</button>
          </div>
          <label id="message"></label>
          <br/>
          <button on-click="signIn()">Sign In</button>
          <button on-click="signUp()">Sign Up</button>
        </div>
        <div template if="showSignOut">
          <button on-click="member()">{{ signedInMember.code }}</button>
          <button on-click="signOut()">Sign Out</button>
        </div>
        <div template if="showMember">
          <x-member-update 
            member="{{ signedInMember }}" members="{{ members }}">
          </x-member-update>
        </div>
        <style>
          button {
            padding: 1px;
            background: #ffcc99;
            border-right: 1px solid #999;
            border-bottom: 1px solid #999;
            border-style: outset;
            border-color: #d7b9c9;
            font-weight: bold;
            text-align: center;
          }
          div {
            padding: 5px;
          }
          #message {
            font-size: 14px;
            background: lightyellow;
          }
        </style>
      </template>
      <script type="application/dart" src="member_sign_in.dart"></script>
    </element>
  </body>
</html>

{% endhighlight %}

When a user clicks on the Sign In button, the signIn method in the MemberSignIn class is executed (Code 10). The input values are validated and if there is a member with the given code and password, the sign in is done.

**Code 10**: MemberSignIn component class.

{% highlight dart %}

import 'package:web_ui/web_ui.dart';

class MemberSignIn extends WebComponent {
  Members members;
  Member signedInMember;

  bool showSignIn = true;
  bool showSignUp = false;
  bool showMember = false;
  bool showSignOut = false;

  signIn() {
    InputElement code = query("#code");
    InputElement password = query("#password");
    LabelElement message = query("#message");
    message.text = '';
    var error = false;
    if (code.value.trim() == '') {
      message.text = 'code is mandatory; ${message.text}';
      error = true;
    }
    if (password.value.trim() == '') {
      message.text = 'password is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      var member = members.find(code.value.trim());
      if (member != null) {
        if (member.password == password.value.trim()) {
          signedInMember = member;
          showSignIn = false;
          showSignUp = false;
          showSignOut = true;
        } else {
          message.text = 'not valid sign in';
        }
      } else {
        message.text = 'not valid sign in';
      }
    }
  }

  signUp() {
    LabelElement message = query("#message");
    message.text = '';
    showSignUp = true;
  }

  add() {
    InputElement code = query("#code");
    InputElement password = query("#password");
    InputElement firstName = query("#firstName");
    InputElement lastName = query("#lastName");
    LabelElement message = query("#message");
    var error = false;
    message.text = '';
    if (code.value.trim() == '') {
      message.text = 'code is mandatory; ${message.text}';
      error = true;
    }
    if (password.value.trim() == '') {
      message.text = 'password is mandatory; ${message.text}';
      error = true;
    }
    if (firstName.value.trim() == '') {
      message.text = 'first name is mandatory; ${message.text}';
      error = true;
    }
    if (lastName.value.trim() == '') {
      message.text = 'last name is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      var member = new Member(code.value);
      member.password = password.value;
      member.firstName = firstName.value;
      member.lastName = lastName.value;
      if (members.add(member)) {
        members.order();
        message.text = 'added, please sign in';
      } else {
        message.text = 'code already in use';
      }
    }
  }

  member() {
    showMember = true;
  }

  signOut() {
    signedInMember = null;
    showSignIn = true;
    showSignUp = false;
    showMember = false;
    showSignOut = false;
  }
}

{% endhighlight %}

A new user may decide to sign up by clicking on the Sign Up button in Figure 1. The showSignUp property becomes true in the signUp method. As a consequence, fields for the first and last name become visible together with the Add button. A click on the Add button without values for the first and last names produces an error message (Figure 3).

![Alt Figure 3: membership] (/img/membership/sign_up_validation.png)

**Figure 3**: Sign up validation.

If all values are entered and the code of a new member is available, the sign up is successful. A user must sign in, in order to make the fields unvisible. The showSignOut property becomes true, while the showSignIn and showSignUp properties become false. However, if a member decides to sign out, only the showSignIn property is true, which gives us again Figure 1.

After a member signs in (Figure 2), she may decide to change her password (Figure 4) by clicking on the button with her code (acr in Figure 2).

![Alt Figure 4: membership] (/img/membership/password_change.png)

**Figure 4**: Password change.

The showMember property in Code 10 becomes true and the member-update component is instantiated (Code 11, a part of Code 9), with two properties initialized.

**Code 11**: Conditional instantiation of the web component.

{% highlight html %}

        <div template if="showMember">
          <x-member-update
            member="{{ signedInMember }}" members="{{ members }}">
          </x-member-update>
        </div>

{% endhighlight %}

The member-update component allows a member to update her password and even to delete her account (Code 12). 

**Code 12**: member-update component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Update</title>
  </head>
  <body>
    <element name="x-member-update" extends="span">
      <template>
        <div>
          <label for="password">Password</label>
          <input id="password" type="password"/>
          <button on-click="change()">Change</button>
          <label id="message"></label>
          <br/>
          <button on-click="delete()">Delete Account</button>
        </div>
        <style>
          button {
            padding: 1px;
            background: #ffcc99;
            border-right: 1px solid #999;
            border-bottom: 1px solid #999;
            border-style: outset;
            border-color: #d7b9c9;
            font-weight: bold;
            text-align: center;
          }
          div {
            padding: 5px;
          }
          #message {
            font-size: 14px;
            background: lightyellow;
          }
        </style>
      </template>
      <script type="application/dart" src="member_update.dart"></script>
    </element>
  </body>
</html>

{% endhighlight %}

Two properties from the MemberSignIn class (Code 10), signedInMember and members, are passed (Code 11) to the component (Code 13), where signedInMember becomes member.

**Code 13**: MemberUpdate component class.

{% highlight dart %}

import 'dart:html';

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberUpdate extends WebComponent {
  Member member;
  Members members;

  change() {
    InputElement password = query("#password");
    LabelElement message = query("#message");
    var error = false;
    message.text = '';
    if (password.value.trim() == '') {
      message.text = 'password is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      member.password = password.value;
      var signInComponent = document.query('x-member-sign-in').xtag;
      signInComponent.showMember = false;
    }
  }

  delete() {
    members.remove(member);
    var signInComponent = document.query('x-member-sign-in').xtag;
    signInComponent.signOut();
  }

}

{% endhighlight %}

The member-update-by-admin component, instantiated in Code 5, uses two new components, member-add and member-find-change-delete in addition to the already used member-list component (Code 14). 

**Code 14**: member-update-by-admin component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Update by Admin</title>
    <link rel="components" href="member_add.html">
    <link rel="components" href="member_find_change_delete.html">
    <link rel="components" href="member_list.html">
  </head>
  <body>
    <element name="x-member-update-by-admin" extends="span">
      <template>
        <content></content>
        <x-member-add members="{{ members }}"></x-member-add>
        <x-member-find-change-delete members="{{ members }}">
        </x-member-find-change-delete>
        <x-member-list members="{{ members }}"></x-member-list>
      </template>
      <script type="application/dart" src="member_update_by_admin.dart">
      </script>
    </element>
  </body>
</html>

{% endhighlight %}

Only the members property is passed (Code 5) to the component (Code 15).

**Code 15**: MemberUpdateByAdmin component class.

{% highlight dart %}

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberUpdateByAdmin extends WebComponent {
  Members members;
}

{% endhighlight %}

An administrator may add a new member (Figure 5).

![Alt Figure 5: membership] (/img/membership/admin_sign_in_list.png)

**Figure 5**: Sign in by an administrator.

The member-add component (Code 16) accepts the members argument (Code 14) that becomes the members property of the MemberAdd class (Code 17).

**Code 16**: member-add component.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Add</title>
  </head>
  <body>
    <element name="x-member-add" extends="span">
      <template>
        <content></content>
        <div>
          <label for="code">Code</label>
          <input id="code" type="text"/>
          <label for="password">Password</label>
          <input id="password" type="password"/>
          <br/>
          <label for="firstName">First Name</label>
          <input id="firstName" type="text"/>
          <label for="lastName">Last Name</label>
          <input id="lastName" type="text"/>
          <br/>
          <button on-click="add()">Add</button>
          <label id="message"></label>
        </div>
        <style>
          button {
            padding: 1px;
            background: #ffcc99;
            border-right: 1px solid #999;
            border-bottom: 1px solid #999;
            border-style: outset;
            border-color: #d7b9c9;
            font-weight: bold;
            text-align: center;
          }
          div {
            padding: 5px;
          }
          #message {
            font-size: 14px;
            background: lightyellow;
          }
        </style>
      </template>
      <script type="application/dart" src="member_add.dart"></script>
    </element>
  </body>
</html>

{% endhighlight %}

**Code 17**: MemberAdd component class.

{% highlight dart %}

import 'dart:html';

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberAdd extends WebComponent {
  Members members;

  add() {
    InputElement code = query("#code");
    InputElement password = query("#password");
    InputElement firstName = query("#firstName");
    InputElement lastName = query("#lastName");
    LabelElement message = query("#message");
    var error = false;
    message.text = '';
    if (code.value.trim() == '') {
      message.text = 'code is mandatory; ${message.text}';
      error = true;
    }
    if (password.value.trim() == '') {
      message.text = 'password is mandatory; ${message.text}';
      error = true;
    }
    if (firstName.value.trim() == '') {
      message.text = 'first name is mandatory; ${message.text}';
      error = true;
    }
    if (lastName.value.trim() == '') {
      message.text = 'last name is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      var member = new Member(code.value);
      member.password = password.value;
      member.firstName = firstName.value;
      member.lastName = lastName.value;
      if (members.add(member)) {
        message.text = 'added';
        members.order();
      } else {
        message.text = 'code already in use';
      }
    }
  }

}

{% endhighlight %}

The member-find-change-delete component extends the member-add component (Code 18).

**Code 18**: Component inheritance.

{% highlight html %}

<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>Member Find Change Delete</title>
  </head>
  <body>
    <element name="x-member-find-change-delete" extends="member-add">
      <template>
        <div>
          <button on-click="find()">Find</button>
          <button on-click="change()">Change</button>
          <button on-click="delete()">Delete</button>
        </div>
      </template>
      <script type="application/dart" src="member_find_change_delete.dart">
      </script>
    </element>
  </body>
</html>

{% endhighlight %}

The find, change and delete buttons in Figure 5 are handled by the find, change and delete methods in the MemberFindChangeDelete class (Code 19) of the member-find-change-delete component.

**Code 19**: MemberFindChangeDelete component class.

{% highlight dart %}

import 'dart:html';

import 'package:membership/membership.dart';
import 'package:web_ui/web_ui.dart';

class MemberFindChangeDelete extends WebComponent {
  Member member;
  Members members;

  find() {
    InputElement code = query("#code");
    InputElement password = query("#password");
    InputElement firstName = query("#firstName");
    InputElement lastName = query("#lastName");
    LabelElement message = query("#message");
    var error = false;
    message.text = '';
    if (code.value.trim() == '') {
      message.text = 'code is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      member = members.find(code.value);
      if (member != null) {
        message.text = 'found';
        password.value = member.password;
        firstName.value =  member.firstName;
        lastName.value =  member.lastName;
      } else {
        password.value = '';
        firstName.value =  '';
        lastName.value =  '';
        message.text = 'not found';
      }
    }
  }

  change() {
    InputElement password = query("#password");
    InputElement firstName = query("#firstName");
    InputElement lastName = query("#lastName");
    LabelElement message = query("#message");
    var error = false;
    message.text = '';
    if (password.value.trim() == '') {
      message.text = 'password is mandatory; ${message.text}';
      error = true;
    }
    if (firstName.value.trim() == '') {
      message.text = 'first name is mandatory; ${message.text}';
      error = true;
    }
    if (lastName.value.trim() == '') {
      message.text = 'last name is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      member.password = password.value;
      member.firstName = firstName.value;
      member.lastName = lastName.value;
      message.text = 'changed';
    }
  }

  delete() {
    InputElement code = query("#code");
    InputElement password = query("#password");
    InputElement firstName = query("#firstName");
    InputElement lastName = query("#lastName");
    LabelElement message = query("#message");
    message.text = '';
    if (members.remove(member)) {
      code.value =  '';
      password.value = '';
      firstName.value =  '';
      lastName.value =  '';      
      message.text = 'deleted';
    } else {
      message.text = 'not deleted';
    }
  }

}

{% endhighlight %}

A member found based on her code (Figure 6), may be updated (the Change button) or deleted by a signed in administrator.

![Alt Figure 6: membership] (/img/membership/member_found_by_admin.png)

**Figure 6**: Member found by an administrator.

There is also a possibility of reusing the member-add component in the member-sign-in component. Try it out.

The model of the application is in the lib folder. The lib folder contains also the membership.dart file that defines the membership library (Code 20).

**Code 20**: Library.

{% highlight dart %}

library membership;

part 'model/members.dart';

{% endhighlight %}

The Member and Members classes of the model are placed in the members.dart file (Code 21), which is located in the model folder.

**Code 21**: Model.

{% highlight dart %}

part of membership;

class Member {
  String code;
  String password = '';
  String firstName;
  String lastName;
  bool admin = false;

  Member(this.code);

  int compareTo(Member member) {
    if (lastName != null && firstName != null) {
      int comparison = lastName.compareTo(member.lastName);
      if (comparison == 0) {
        comparison = firstName.compareTo(member.firstName);
      }
      return comparison;
    }
  }

  String toString() {
    return '${lastName}, ${firstName}';
  }

  display() {
    print(toString);
  }
}

class Members {
  var _members = new List<Member>();
  
  Iterator<Member> get iterator => _members.iterator;

  bool add(Member member) {
    if (contain(member.code)) {
      return false;
    } else {
      _members.add(member);
      return true;
    }
  }

  List<Member> toList() => _members;

  order() {
    _members.sort((m,n) => m.compareTo(n));
  }

  bool contain(String code) {
    if (code != null) {
      for (Member member in _members) {
        if (member.code == code) {
          return true;
        }
      }
    }
    return false;
  }

  Member find(String code) {
    if (code != null) {
      for (Member member in _members) {
        if (member.code == code) {
          return member;
        }
      }
    }
  }

  bool remove(Member member) {
    if (member == null || member.code == null) {
      return false;
    }
    for (Member m in _members) {
      if (m.code == member.code) {
        int index = _members.indexOf(m, 0);
        _members.removeAt(index);
        return true;
      }
    }
    return false;
  }

  display() {
    _members.forEach((m) {
      m.display();
    });
  }
}

{% endhighlight %}

The pubspec.yaml file must be in the root folder of the membership application (Code 22).

**Code 22**: Pub specification.

{% highlight yaml %}

name:  membership
author: Dzenan Ridjanovic <dzenanr@gmail.com>
homepage: http://ondart.me/
version: 0.0.4
description: > 
  A sample application with web components.
dependencies:
  browser: any
  web_ui: any

{% endhighlight %}

There are two dependencies in the pub specification. The dart.js bootstrap file (Code 3) is now placed in the browser package. The last version of the web_ui package is also obtained from Pub.
