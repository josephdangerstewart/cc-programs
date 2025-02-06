import fs from "node:fs";
import path from "node:path";

const [, , ...projectsArg] = process.argv;

const projectsRoot = path.join(__dirname, "..", "projects");

const projects = projectsArg.length
	? projectsArg
	: fs.readdirSync(projectsRoot);

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
		if (!fs.existsSync(target)) {
			fs.mkdirSync(target, { recursive: true });
		}

		for (const existingItem of fs.readdirSync(target)) {
			fs.rmSync(path.join(target, existingItem), { recursive: true, force: true });
		}

		fs.cpSync(projectPath, target, {
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
}
