# Printer spooler monitoring in Solarwinds
This is a script and APM template for monitoring a printer spooler on Windows server, for files over a certian size limit.

## Download
You can download the template from the [releases page](/releases) under assets.

## Usage in Solarwinds
### Importing the template
1. Go to "SAM Settings".
2. Then "Manage Templates" under "APPLICATION MONITOR TEMPLATES".
3. Import the file from the toolbar (at the top of the table).

### Creating a node
1. Go to "Manage Nodes"
2. Click "Add Node"
3. Hostname/IP should be the node you want to monitor.
4. Polling Method should be "Windows servers", and choose a credential.
5. Polling Engine should be a server with Powershell installed.
6. Click next.
7. Show only the tag "Printer" and choose the "Printer spool jobs" template.
8. Type in your printer queue and desired job-size limit (in bytes) in the script arguments. (PRINTER-QUEUE,3000000000)
9. Click next, and add the component to a group or a view.

## License
[MIT](LICENSE)