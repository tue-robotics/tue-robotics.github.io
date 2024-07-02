^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package smach
^^^^^^^^^^^^^^^^^^^^^^^^^^^

2.0.4 (2019-08-09)
------------------

2.0.3 (2019-05-20)
------------------
* Merge pull request `#9 <https://github.com/mojin-robotics/executive_smach/issues/9>`_ from LoyVanBeek/feature/concurrent_exceptions
  Feature/concurrent exceptions
* Put the raw exception in a dict, not the formatted exception
* Add formatted child-exception to parent-Concurrence exception handling
* Contributors: Felix Messmer, Loy van Beek

2.0.2 (2019-03-14)
------------------
* Merge pull request `#8 <https://github.com/mojin-robotics/executive_smach/issues/8>`_ from benmaidel/more_debugging
  additional logging
* additional logging
* Merge pull request `#7 <https://github.com/mojin-robotics/executive_smach/issues/7>`_ from benmaidel/fix/sm_preemption
  service preemption on StateMachine
* service preemption on StateMachine
* Merge pull request `#6 <https://github.com/mojin-robotics/executive_smach/issues/6>`_ from benmaidel/more_debugging
  added more debugging output
* added more debugging output
* Merge pull request `#5 <https://github.com/mojin-robotics/executive_smach/issues/5>`_ from benmaidel/additional_logging
  added more debugging output
* added more debugging output
* Merge pull request `#4 <https://github.com/mojin-robotics/executive_smach/issues/4>`_ from benmaidel/fix/concurrent_preemption
  Fix/concurrent preemption
* overwrite outcome to "preempted" on already finished states when concurrent container preempts
* print warning on preemption error
* Merge pull request `#3 <https://github.com/mojin-robotics/executive_smach/issues/3>`_ from benmaidel/fix/state_transitions
  fix state transitions and preemption behaviour
* removed preemption outcome from smach.CBState because smach.StateMachine will handle this cases
* add preemption to callback states
* no not service preemption before running state is set to preemption
* Merge branch 'indigo-devel' of github.com:unity-robotics/executive_smach into indigo-devel
* merge
* fix syntax error for logging
* Merge pull request `#2 <https://github.com/mojin-robotics/executive_smach/issues/2>`_ from ipa-fmw/fix/iterator_preemption
  fix syntax error for logging
* Merge pull request `#5 <https://github.com/mojin-robotics/executive_smach/issues/5>`_ from ipa-bnm/fix/iterator_preemption
  fixed possible iterator preemption error
* fix syntax error for logging
* fixed possible iterator preemption error
* Merge pull request `#1 <https://github.com/mojin-robotics/executive_smach/issues/1>`_ from ipa-bnm/indigo-devel
  modifications for project
* Merge branch 'feature/ConcurrencyFix' of github.com:athackst/executive_smach into indigo-devel
* small cleanup
* added request_shutdown function, added checks on _shutdown_requested to cleanly exit statemachine and concurrence
* Merge branch 'feature/ConcurrencyFixTemp' into feature/ConcurrencyFix
* added shutdown handler, added threaded start to smach_ros
* removed check of smach.is_shutdown from waiting for threads to terminate -- may or may not be a good idea
* fixed ctrl+C on a concurrence container
* Contributors: Allison Thackston, Benjamin Maidel, Felix Messmer, Florian Weisshardt, ipa-fmw

2.0.1 (2017-06-08)
------------------
* [maintenance] Update maintainer. switching to package.xml format 2
* Contributors: Isaac I.Y. Saito

2.0.0 (2014-04-17)
------------------
* Merging changes, resolving conflicts, from strands-project (@cburbridge)
* cleaning up and removing rosbuild support
* merging groovy and hydro
* Fix get_internal_edges returning list of tuples, not list of lists
* Remove old methods set_userdata
* Remove superfluous parent class declaration 'UserData' from 'Remapper'
* Add local error base class 'SmachError', extending Exception
* Fix syntax errors, doc typos and indentations glitches
* Fixed invalid exception type in concurrence.py
* Checking threads have fully terminated before cleanup of outcomes dict
  This commit uses thread.isAlive() on each concurrent state runner to check for termination of all the threads before continuing. This is necessary as only checking that the outcome has been filled in does not mean the thread has completed; if the thread has not completed it may not yet have called the termination callback. If this loop exits before the termination callback of the last thread is called, then the callback will occasionally be sent an empty dictionary (when the main thread has got to line 305).
* cope with missed state termination notifications
  Concurrent states could terminate and notify _ready_event without the concurrence container realising, as it could be busy checking the outcome values. This makes the concurrency container get stuck on line 250. This commit adds a timeout to the wait to safely cope with missing notifications.
* Adding event for thread synchronization in concurrence and using event not condition in monitor state
* Contributors: Felix Kolbe, Jonathan Bohren, Piotr Orzechowski, cburbridge

1.3.1 (2013-07-22)
------------------
* adding changelogs
* added missing catkin_package() calls in CMakeLists.txt files of packages smach and smach_ros
* Updating maintainer name

* added missing catkin_package() calls in CMakeLists.txt files of packages smach and smach_ros
* Updating maintainer name
