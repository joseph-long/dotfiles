# JupyterLab configuration

# Disable server-side workspace persistence.
#
# JupyterLab saves per-window UI layout ("workspaces") to
# ~/.jupyter/lab/workspaces/*.jupyterlab-workspace and restores them on launch.
# Setting workspaces_dir to "" means the workspaces API handler is never
# registered (see jupyterlab_server/handlers.py: `if extension_app.workspaces_dir`),
# so nothing is saved or restored and each launch starts with a fresh layout.
# This avoids stale restore errors from removed extensions / renamed files.
c.LabApp.workspaces_dir = ""
