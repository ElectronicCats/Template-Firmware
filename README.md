# Template-Firmware

## Cómo usar esta plantilla

La mayoría de los proyectos de Electronic Cats tienen la siguiente estructura de directorios:

```bash
.
├── firmware
│  └── archivos
├── hardware
│  └── archivos
```

Si estás por agregar firmware a un proyecto desde cero o que ya tenga un proyecto de diseño de hardware iniciado, lo que tienes que hacer es copiar el contenido de este repositorio a al proyecto en el que vas a trabajar y eliminar la carpeta de git perteneciente a este repositorio.

Posibles comandos que te podrían ser de utilidad:

1. Copiar esta plantilla al proyecto en el que vas a trabajar.

```bash
cp -r Template-Firmware/ badge-recon-2025/firmware/
```

> Reemplaza`badge-recon-2025/` con el nombre del directorio del proyecto en el que vas a trabajar, pero manten la copia dentro del subdirectorio `firmware/`

2. Entra al direcotorio del nuevo proyecto

```bash
cd badge-recon-2025/
```

3. Crea una rama de desarrollo si no existe o cualquiera que se ajuste a tus necesidades. Por ejemplo:

```bash
git branch -M dev
```

4. Elimina el directorio `.git/` dentro de `firmware/`.

```bash
rm -rf firmware/.git
```

5. Agrega el nuevo directorio a git y haz commit de ello.

```bash
git add firmware/ && git commit -m "chore: add firmware template"
```

> Recuerda hacer tus commits siguiendo las conveciones de [conventinal commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Posibles problemas

Si te aparece un mensaje de error como el siguiente, quiere decir que no borraste el directorio `.git/` dentro de `firmware/`, solo eliminalo y repite a partir del paso 4.

```bash
warning: adding embedded git repository: firmware
hint: You've added another git repository inside your current repository.
hint: Clones of the outer repository will not contain the contents of
hint: the embedded repository and will not know how to obtain it.
hint: If you meant to add a submodule, use:
hint:
hint: 	git submodule add <url> firmware
hint:
hint: If you added this path by mistake, you can remove it from the
hint: index with:
hint:
hint: 	git rm --cached firmware
hint:
hint: See "git help submodule" for more information.
hint: Disable this message with "git config advice.addEmbeddedRepo false"
```
