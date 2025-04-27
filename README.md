# Bellroy

Elm project using Vite for the bundling and Express to mock the back-end.

## Try it out

1. Clone this project

```
git clone git@github.com:ivanbanov/bellroy.git
```

2. Install all dependencies

```
pnpm install
```

3. Run the backend mock server

```
pnpm backend
```

4. Run the dev server

```
pnpm dev
```

The mock server will load random items and simulate loading delay a realworld UX.
The products options are simulated with "tinted" images for the simplicity of the project.

Access [http://localhost:5173/](http://localhost:5173/)

## Storybook (elm-book)

```
pnpm storybook
```

## Tests

The project is tested with `elm-test`, ensuring type safety and functional correctness through automated tests.

```
pnpm test
```

## Features

### Responsive layout

The layout looks great on all screen sizes, from mobile to desktop.

![](./readme/responsive.gif)

### Image load error handler

Reliable UI, even if an image fails to load, a placeholder will be shown. No broken layouts, no crashes.

![](./readme/image-error.png)

### Accessibility

Full keyboard support and proper ARIA attributes for screen readers. Product colors can be picked by arrow navigation ([listbox ARIA spec](https://developer.mozilla.org/de/docs/Web/Accessibility/ARIA/Reference/Roles/listbox_role)).

![](./readme/voice-over.gif)

### Mini UI libray

Isolated, reusable views, crafted in a sandbox for smooth development and clear docs.

![](./readme/storybook.png)
