[![tests](https://github.com/ddev/ddev-gitpod-setup/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-gitpod-setup/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

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

Please refer to the official [DDEV-addon-template README](https://github.com/ddev/ddev-addon-template?tab=readme-ov-file#how-to-debug-tests-github-actions) for a detailed guide.

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
