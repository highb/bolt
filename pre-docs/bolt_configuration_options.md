
# Bolt configuration options

Your Bolt config file can contain global and transport options.


## Sample Bolt config file

```yaml
modulepath: "~/.puppetlabs/bolt-code/site:~/.puppetlabs/bolt-code/modules"
inventoryfile: "~/.puppetlabs/bolt/inventory.yaml"
concurrency: 10
format: human
ssh:
  host-key-check: false
  private-key: ~/.ssh/bolt_id
```


## Global configuration options

`concurrency`: The number of threads to use when executing on remote nodes. Default is 100.

`format`: The format to use when printing results. Options are human and json. Default is human.

`modulepath`: The module path for loading tasks and plan code. This is a list of
directories seperated by the OS specific file path seperator.

`inventoryfile`: The path to a structured data inventory file used to refer to
groups of nodes on the commandline and from plans.

`color`: Whether to use colored output when printing messages to the console.

## SSH transport configuration options

`host-key-check`: Whether to perform host key validation when connecting over SSH. Default is true.

`private-key`: The path to the private key file to use for SSH authentication.

`connect-timeout`: How long Bolt should wait when establishing connections.

`tmpdir`: The directory to upload and execute temporary files on the target.


## WinRM transport configuration options
`connect-timeout`: How long Bolt should wait when establishing connections.

`ssl`: When true, Bolt will use normal http connections for winrm. The default is true.

`tmpdir`: The directory to upload and execute temporary files on the target.

`cacert`: The path to the CA certificate.

`extensions`: List of file extensions that are accepted for scripts or tasks.
Scripts with these file extensions rely on the target node's file type
association to run. For example, if Python is installed on the system, a .py
script should run with python.exe. The extensions .ps1, .rb, and .pp are
always allowed and run via hard-coded executables.


## PCP transport configuration options

`service-url`: The url of the orchestrator API.

`cacert`: The path to the CA certificate.

`token-file`: The path to the token file.

`task-environment`: The environment orchestrator should load task code from.


## Log file configuration options

Capture the results of your plan runs in a log file.

`log`: the configuration of the log file output. This option includes the following properties:

- `console` or `path/to.log`: the location of the log output.
- `level`: the type of information in the log. Your options are debug, verbose, notice, warn.
- `append`: add output to an existing log file. Available for only for logs output to a filepath. Your options are true (default) and false.

```
log:
  console:
    level: :info
  ~/.bolt/debug.log:
    level: :debug
    append: false
```
