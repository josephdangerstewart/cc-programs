import fs from "node:fs";
import path from "node:path";

const [, , ...projectsArg] = process.argv;

const projectsRoot = path.join(__dirname, "..", "projects");

const projects = projectsArg.length
	? projectsArg
	: fs.readdirSync(projectsRoot);

const pushedTargetsByProject: Record<string, string[]> = Object.fromEntries(projects.map(project => ([project, []])));

for (const project of projects) {
	const projectPath = path.join(projectsRoot, project);
	const targetsJsonPath = path.join(projectPath, "targets.json");
	if (!fs.existsSync(targetsJsonPath)) {
		continue;
	}

	const { targets } = JSON.parse(
		fs.readFileSync(targetsJsonPath, { encoding: "utf-8" })
	);

	if (!Array.isArray(targets)) {
		throw new Error("Invalid contents");
	}

	for (const target of targets) {
		copyProject(project, target);
		pushDependencies(project, target);
	}
}

function pushDependencies(project: string, target: string) {
	const configJsonPath = path.join(projectsRoot, project, 'config.json');

	if (!fs.existsSync(configJsonPath)) {
		return;
	}

	const { dependencies } = JSON.parse(
		fs.readFileSync(configJsonPath, { encoding: 'utf-8' })
	);

	if (!Array.isArray(dependencies)) {
		return;
	}

	for (const dependencyProject of dependencies) {
		const dependencyProjectPath = path.join(projectsRoot, dependencyProject);
		if (!fs.existsSync(dependencyProjectPath)) {
			console.error(`invalid dependency in ${project}: ${dependencyProject}`);
			continue;
		}

		copyProject(dependencyProject, target);
		pushDependencies(dependencyProject, target);
	}
}

function copyProject(project: string, target: string) {
	const projectPath = path.join(projectsRoot, project);
	const targetsJsonPath = path.join(projectPath, 'targets.json');
	const targetPath = path.join(target, project);

	if (!fs.existsSync(projectPath)) {
		console.error(`tried to push invalid project: ${project}`);
		return;
	}

	// We've already copied this project and it's dependencies to this target
	if (pushedTargetsByProject[project].includes(targetPath)) {
		return;
	}

	if (!fs.existsSync(targetPath)) {
		fs.mkdirSync(targetPath, { recursive: true });
	}

	for (const existingItem of fs.readdirSync(targetPath)) {
		fs.rmSync(path.join(targetPath, existingItem), { recursive: true, force: true });
	}

	pushedTargetsByProject[project].push(targetPath);

	console.log(`copying ${project} to ${targetPath}`);
	fs.cpSync(projectPath, targetPath, {
		recursive: true,
		force: true,
		filter: (x) => {
			if (x.endsWith(targetsJsonPath)) {
				return false;
			}
			return true;
		},
	});
}