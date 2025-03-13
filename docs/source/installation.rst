Installation
########################

You'll find here information about how to make MIMICWizard work on your computer/infrastructure.

Before starting you should keep in mind that MIMICWizard is divided in 2 part, the **application** run with R-Shiny and the **database** run with PostgreSQL

Install the local application (Run from RStudio or R CLI)
*********************************************************
*Theses instructions are the simplest way to get MIMICWizard running, but it's not the way it is intended to be hosted and distributd to multiple users in your organization*

You can download the MIMICWizard **source code** using git or directly by zip downloading from GitHub.

.. code-block:: bash

   git clone <not_available_yet>

In order to install the app, you'll need to have **R 4.4** installed `R official repository (CRAN) <https://cran.r-project.org/mirrors.html>`_ 

For Windows user, you need to install Rtools to compile some of the packages, available on the `Rtools official repository <https://cran.r-project.org/bin/windows/Rtools/>`_

Once R is installed, open a terminal in the project directory (i.e. in the app/ folder) and run the following command to install the required packages :

.. code-block:: bash

   R -e "renv::restore()"


This step should take a few minutes, go grab a coffee ☕ 

Your coffee is finished but the package installation is still ongoing ? Don't worry, you can carry to the next step and let the installation finish in the background.

Now you need to install the **PostgreSQL server** that will hold the database. 

You can download the latest version of PostgreSQL with your favorite package manager for UNIX user or on the `PostgreSQL official repository <https://www.postgresql.org/download/>`_ for windows user.

.. note::

   Alternatively, Windows 10 users (Windows 11 is not supported) can use `PostgreSQL Portable <https://github.com/rsubr/postgresql-portable>`_ (originally developed by ``garethflowers``, kept up-o-date by ``rsubr``) which, as is name discreetly suggest is a portable implementation of a PostgreSQL database manager.
   *Note that it's possible to host the full MIMIC-IV database in the portable version but it's not recommended due to performance issue*

You should then import the MIMIC-IV database in your PostgreSQL server.

There's now two choices :

* `Use  MIMIC-IV demo <Import MIMIC-IV demo to your PostgreSQL server_>`_ 

* `Use  MIMIC-IV demo <Import MIMIC-IV full version to your PostgreSQL server_>`_ 


Import MIMIC-IV demo to your PostgreSQL server
**********************************************

* Download the MIMIC-IV demo database available on the `Physionet Repository - MIMIC-IV Clinical Database demo <https://physionet.org/content/mimic-iv-demo/>`_ (the download button is at the bottom of the page).
* Unzip the database in the demo folder at the MIMICWizard root repository

Your MIMICWizard root repository should now look like that 

.. code-block::

   cache
   demo/
   -- hosp/
   -- icu/
   -- ...
   R/
   renv/
   app.R
   DESCRIPTION
   renv.lock

If it's the case that's perfect, you just have to run ``PostgreSQLPortable.exe`` before launching the app and that's it, your demo database will be automatically populated on MIMICWizard startup.

.. tip:: 

   Use the Init Demo procedure on the application homepage the first time you connect to the database with MIMICWizard. This procedure will use the file in the demo folder to populate your database. Once it has been done one time, you could use the run demo procedure.

Import MIMIC-IV full version to your PostgreSQL server
******************************************************
In order to host the full database, please follow the guide edited by the Physionet repository : `Buid MIMIC (from mimic-code) <https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv/buildmimic/postgres>`_.



The application also need extra derived table provided by MIT-LCP. The installation procedure is available in the `Concepts Postgres (from mimic-code) <https://github.com/MIT-LCP/mimic-code/tree/main/mimic-iv/concepts_postgres>`_ folder.

.. tip:: 

   Windows user will need to install `gzip <https://gnuwin32.sourceforge.net/packages/gzip.htm>`_ and add gzip and postgresql to the PATH environment variable.
   Postgres run command with your windows user as default, you should add the argument `-U postgres` to use the default postgres user.

Start MIMICWizard
******************

Once you've installed the atabase, you need to install the internal data table needed by MIMICWizard. Install the using the script available `here <assets/mimicwizard_internal_init.sql>`_

Now you're database is ready to work with MIMICWizard, configure the correct authentification parameters in the configuration file (details below) to make the final link between database and application.

Once all the packages are downloaded and installed, database is loaded, and `configuration file <Configuration file_>`_ configured, **MIMICWizard is ready**. 

**Make sure your database is running**, cd to the app directory and run :

.. code-block:: bash

   R -e "shiny::runApp()"


Configuration file
*************************
The configuration file is located at the root of MIMIWizard folder. This file is named ``global.R`` and store all the configuration options.


+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Configuration option | Possible value                            | Description                                                                                                                                                      |
+======================+===========================================+==================================================================================================================================================================+
| **INTERACTIVE**      | - TRUE                                    | Do you want to activate the application landing page where user can choose if he want to use demo or hosted database. Should be disabled for hosted application. |
|                      | - FALSE                                   |                                                                                                                                                                  |
+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **CACHE_DIR**        | empty string or <path/to/cache/folder>    | Repository where the application cache object are written                                                                                                        |
|                      |                                           | Default "" create a cache folder in the application directory                                                                                                    |
|                      |                                           | Shiny Server should have writing rights in this folder                                                                                                           |
|                      |                                           | Need a closing /                                                                                                                                                 |
|                      |                                           |                                                                                                                                                                  |
+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **APPLICATION_MODE** | - INIT_DEMO                               | Force application mode, only if interactive is set to FALSE                                                                                                      |
|                      | - DEMO                                    |                                                                                                                                                                  |
|                      | - HOSTED                                  | - INIT_DEMO will regenerate the demo database and override the existing demo database                                                                            |
|                      |                                           | use this mode if you have only one user at the same time and want the database to be clean each time the user start the app.                                     |
|                      |                                           |                                                                                                                                                                  |
|                      |                                           | - DEMO run the application in restricted mode, the application will use the demo database configuration. Some function won't be available.                       |
|                      |                                           |                                                                                                                                                                  |
|                      |                                           | - HOSTED run the application in full mode, the application will use the hosted database configuration.                                                           |
+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **HOSTED_DBNAME**,   | Your database configuration, if it exists |                                                                                                                                                                  |
| **HOSTED_HOST**,     |                                           |                                                                                                                                                                  |
| **HOSTED_PORT**,     |                                           |                                                                                                                                                                  |
| **HOSTED_USER**,     |                                           |                                                                                                                                                                  |
| **HOSTED_PASSWORD**  |                                           |                                                                                                                                                                  |
+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| **DEMO_DBNAME**,     | The demo database configuration           | If you're using default postgres configuration, you shouldn't have anything to change                                                                            |
| **DEMO_HOST**,       |                                           |                                                                                                                                                                  |
| **DEMO_PORT**,       |                                           |                                                                                                                                                                  |
| **DEMO_USER**,       |                                           |                                                                                                                                                                  |
| **DEMO_PASSWORD**    |                                           |                                                                                                                                                                  |
+----------------------+-------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Host the application on your infrastructure
*********************************************************
You can host MIMICWizard using `Posit Shiny Server <https://posit.co/download/shiny-server/>`_ 

They provide a detailed documentation about how to deploy a Shiny Application in their `Administrator Guide <https://docs.posit.co/shiny-server/>`_
The combination of the current page and the Posit documentation should be sufficient to deploy MIMICWizard considering your infrastructure modalities.


.. danger:: MIMICWizard has not been build to be injection-free and without vunerabilities. As a result, **I strongly discourage to distribute this app on a public infrastructure.**
   
   Also, I recommend to give **read-only rights to the database user** you're using in the app **on MIMIC-IV Data**.
   Note that database user should have writing right on public schema as its mandatory for app content to work as intented.