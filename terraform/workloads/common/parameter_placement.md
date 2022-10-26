#common-variables.tf
Parameter is put into common-variables.tf if it has the same validation scheme and possible values for all of the workloads where it can be used.

#<provider>-variables.tf
This file should contain variables which have a validation scheme which is CSP-dependent, like storage types or instance types. The naming schemes are different between various CSPs.  
It is impossible to make validation dependent on two variables at once (e.g. provider + instancetype), so division into files is necessary to achieve separate validation schemes (at least as of 08 Feb 2022).

#<benchmark>-workload-specific-variables.tf
This file should contain variables which have a validation scheme that is benchmark-dependent, yet independent from CSP. Also variables which are used in only one benchmark should be put in this type of variable files.

#<benchmark>-<csp>-workload-specific-variables.tf
This file should ONLY contain variables which have a validation scheme that is both benchmark and CSP dependent. Existence of such files might be a sign to think about refactoring the modules, because these types of variable files should be kept to a lowest reasonable minimum.
