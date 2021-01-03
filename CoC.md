#Code of Conduct:
1. Every function, variable or input action must be in snake case standard (https://en.wikipedia.org/wiki/Snake_case).
2. Enums are data types and should be written in Camel Case (https://en.wikipedia.org/wiki/Camel_case), where every word is starting from capital letter and no underscores between.
3. Members of Enum types are de-facto constants and should be written all in capital letters with underscores between words, ie:
	enum ExampleEnum {
			OPTION1,
			OPTION2,
		}
4. All constants must be written in capital lettesr just like members of Enum types:
	const DUMMY_CONSTANT := 0
5. File names are using naming conventions from point 2.
6. Numbers must be separated by comma nad space which means Vector2(1,1) should be written as Vector2(1, 1) or in case of Godot use built in constant: Vector2.ONE
7. Every mathematical operator must be separated by space instead of 2+2=4 write 2 + 2 = 4 or 6 / 2 = 3
8. We must always default to built in engine futures before implementing our own in GDScript. Engine build in functions are driven by C++ and are extremely fast.
9. We must try to implement custom game functionality in GDScript as it is portable without hassle between all platforms supported by Godot.
10. When performance of code is issue we must first try to optimize GDScript (why look at 9). If it wont solve problem then we will use GDNative (Rust/C++ preffered).
11. We wont use Singleton (Autolad) for game state, instead we will use shared resource as an inject dependency to all scenes that require that kind of data.
12. Godot doesn't have structs, we will use Resources instead.
13. Artists will separate their raw (project) files from production files to different folders. Blender (*.blend) files shouldn't be in the same folder as files exported from 3d software. We can have "raw_assetes" folder for files used by artists and "assets" folder that is used by game internally.

Any suggestions?
