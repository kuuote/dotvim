err := filepath.Walk({{_input_:path}}, func(path string, info os.FileInfo, err error) error {
	if err != nil {
		fmt.Printf("prevent panic by handling failure accessing a path %q: %v\n", path, err)
		return err
	}
	{{_cursor_}}
	return nil
})
if err != nil {
	return err
}
