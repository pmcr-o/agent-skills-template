# Create a .NET project from a template (GitHub Actions)

This repository ships a manual workflow that runs `dotnet new install` (optional) and `dotnet new`, then builds and tests the generated project as PMCR-O evidence.

**[▶ Run the workflow](../../../actions/workflows/dotnet-new-template.yml)**

On the page that opens, press **Run workflow**, fill in the inputs, and start it. GitHub requires a signed-in user with write access to dispatch a workflow, so this link opens the run form instead of triggering anything by itself.

## Inputs

| Input | Meaning | Default |
| --- | --- | --- |
| `template-package` | Optional template package to install first (NuGet id, `id::version`, or a path in the repo) | empty |
| `template` | `dotnet new` short name, for example `console`, `classlib`, `webapi`, `xunit` | `console` |
| `project-name` | Name of the generated project | `SampleApp` |
| `framework` | `net8.0`, `net9.0` or `net10.0` | `net10.0` |
| `dotnet-version` | SDK version or range to install | `10.0.x` |
| `run-tests` | Run `dotnet test` after the build | `true` |

## What it does

1. Installs the .NET SDK (`actions/setup-dotnet`).
2. Validates the inputs, which are passed to the shell only through environment variables.
3. Runs `dotnet new install <template-package>` when a package is given.
4. Runs `dotnet new <template> --name <project-name> --framework <framework>`.
5. Builds and tests the result through `.github/actions/pmcro-dotnet`.
6. Uploads the generated project as a workflow artifact.

## Authority boundary

The workflow produces evidence only. It does not grant PMCR-O authority and does not approve deployment; an independent CHECK still decides. See `pmcro-agent/docs/ACTIONS-ACCOUNTABILITY.md`.

## Command line alternative

```bash
gh workflow run dotnet-new-template.yml -f template=webapi -f project-name=MyApi -f framework=net10.0
```
