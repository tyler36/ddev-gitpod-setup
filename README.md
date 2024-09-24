[![tests](https://github.com/tyler36/ddev-gitpod-setup/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-gitpod-setup/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# ddev-gitpod-setup <!-- omit in toc -->

- [What is ddev-gitpod-setup?](#what-is-ddev-gitpod-setup)
- [Getting started](#getting-started)
- [Customizing](#customizing)
    - [Full control](#full-control)
    - [Project-type customizing](#project-type-customizing)
- [Components of the repository](#components-of-the-repository)
- [Contributing](#contributing)
    - [How to debug tests (Github Actions)](#how-to-debug-tests-github-actions)

## What is ddev-gitpod-setup?

ddev-gitpod-setup is a helper add-on to setup Gitpod for a DDEV project.
It does this by generating a `.gitpod.yml` file which includes:

- generic framework-specific tasks
- DDEV base image
- DDEV port settings
- VSCode extensions
- GitHub preferences

@see <https://www.gitpod.io/docs/references/gitpod-yml> for options settings.

## Getting started

1. Install add-on

    ```shell
    ddev get tyler36/ddev-gitpod-setup
    ```

2. Commit file to repository.
3. Open the project in Gitpod.

@see <https://www.gitpod.io/docs/introduction/getting-started>. This addon generates a `.gitpod.yml` file from step 3.

## Customizing

### Full control

- Remove `#ddev-generated` from `.gitpod.yml`.
- Make changes, as require.

Note: This addon will no longer manage the file.
You are responsible for all updates to the configuration such as updating the DDEV version.
You will need to manually remove the file if/when you remove this add-on.

### Project-type customizing

- Remove `#ddev-generated` from `.ddev/gitpod-setup/{project-type}.yml`
  Hint: You can find your `project-type` in `.ddev/config.yml` under `type`.
- Update `.ddev/gitpod-setup/{project-type}.yml` tasks.
- Run `ddev get tyler36/ddev-gitpod-setup` to generate a new config file.

This approach works best if you want to:

- customize Gitpod tasks.
- allow this add-on to update the DDEV image, ports and other "standard" DDEV configuration.
- reuse the project-type settings in other projects.

## Components of the repository

- [gitpod-setup](gitpod-setup/) directory holds the files used to construct the final `.gitpod.yml` file.
- An [install.yaml](install.yaml) file that describes how to install the service or other component.
- A test suite in [test.bats](tests/test.bats) that makes sure the service continues to work as expected.
- [Github actions setup](.github/workflows/tests.yml) so that the tests run automatically when you push to the repository.

## Contributing

PRs are welcome, especially when accompanied with tests.

Project-type files are also welcome. However, please take care to keep them as minimal and un-opinionated.
We all have our preferred setup environment and "essential" extensions and add-ons. They are outside this add-ons scope. @see [customizations](#customizing).

### How to debug tests (Github Actions)

1. You need an SSH-key registered with GitHub. You either pick the key you have already used with `github.com` or you create a dedicated new one with `ssh-keygen -t ed25519 -a 64 -f tmate_ed25519 -C "$(date +'%d-%m-%Y')"` and add it at `https://github.com/settings/keys`.

2. Add the following snippet to `~/.ssh/config`:

```config
Host *.tmate.io
    User git
    AddKeysToAgent yes
    UseKeychain yes
    PreferredAuthentications publickey
    IdentitiesOnly yes
    IdentityFile ~/.ssh/tmate_ed25519
```

3. Go to `https://github.com/<user>/<repo>/actions/workflows/tests.yml`.

4. Click the `Run workflow` button and you will have the option to select the branch to run the workflow from and activate `tmate` by checking the `Debug with tmate` checkbox for this run.

![tmate](images/gh-tmate.jpg)

5. After the `workflow_dispatch` event was triggered, click the `All workflows` link in the sidebar and then click the `tests` action in progress workflow.

7. Pick one of the jobs in progress in the sidebar.

8. Wait until the current task list reaches the `tmate debugging session` section and the output shows something like:

```
106 SSH: ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
107 or: ssh -i <path-to-private-SSH-key> PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
108 SSH: ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
109 or: ssh -i <path-to-private-SSH-key> PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
```

9. Copy and execute the first option `ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io` in the terminal and continue by pressing either <kbd>q</kbd> or <kbd>Ctrl</kbd> + <kbd>c</kbd>.

10. Start the Bats test with `bats ./tests/test.bats`.

For a more detailed documentation about `tmate` see [Debug your GitHub Actions by using tmate](https://mxschmitt.github.io/action-tmate/).

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
