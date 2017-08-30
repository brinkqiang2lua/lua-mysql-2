--
-- Premake script (http://premake.github.io)
--

solution 'lua-mysql'
    configurations  {'Debug', 'Release'}
    targetdir       'bin'

    filter 'configurations:Debug'
        defines { 'DEBUG' }
        symbols 'On'
        

    filter 'configurations:Release'
        defines { 'NDEBUG' }
        symbols 'On'
        optimize 'On'


    filter 'action:vs*'
        defines
        {
            'WIN32',
            'WIN32_LEAN_AND_MEAN',
            '_WIN32_WINNT=0x0600',
            '_CRT_SECURE_NO_WARNINGS',
            'NOMINMAX',
            'inline=__inline',
			'LUA_BUILD_AS_DLL',
        }

    filter 'action:gmake'
        buildoptions  '-std=c99'

	project 'lua'
        targetname 'lua'
        location 'build'
        language 'C'
        kind 'ConsoleApp'

        files
        {
            'dep/lua/src/lua.c',
        }
        links 'lua5.3'

        filter 'system:linux'
            defines 'LUA_USE_LINUX'
            links { 'm', 'dl', 'readline'}

    project 'lua5.3'
        targetname  'lua5.3'
        location    'build'
        language    'C'
        kind        'SharedLib'
        files
        {
            'dep/lua/src/*.h',
            'dep/lua/src/*.c',
        }
        removefiles
        {
            'dep/lua/src/lua.c',
            'dep/lua/src/luac.c',
        }

        filter 'system:linux'
            defines 'LUA_USE_LINUX'


    project 'luamysql'
        targetname  'luamysql'
        location    'build'
        language    'C'
        kind        'SharedLib'

		defines 'LUA_LIB'
        files
        {
            'src/*.h',
            'src/*.c',
        }
        includedirs
        {
            'dep/libmysql',
            'dep/lua/src',
        }
        libdirs 'bin'
        links   'lua5.3'

        filter 'system:windows'
            links 'libmysql'

        filter 'system:linux'
            links 'mysqlclient'
            
