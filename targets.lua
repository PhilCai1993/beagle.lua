local deb = debber()

deb.packageinfo = {
    Package = 'objcbeagle',
    Name = 'Objective Beagle',
    Version = '1.0',
    Architecture = 'iphoneos-arm',
    Description = 'Find Objective-C classes in a process',
    Maintainer = 'Reed Weichler <rweichler+cydia@gmail.com>',
    Author = 'Richard Heard',
    Section = 'Development',
    Depiction = 'https://github.com/rweichler/beagle.lua',
}
deb.input = 'layout'
deb.output = 'objcbeagle.deb'

local folder = '/usr/local/share/lua/5.1/beagle'

function default()
    os.pexecute("rm -rf "..deb.input)

    -- copy lua scripts
    fs.mkdir(deb.input..folder)
    os.pexecute("cp src/lua/*.lua "..deb.input..folder)

    -- compile beagle
    local b = builder('apple')
    b.compiler = 'clang'
    b.src = fs.scandir('src/lib/*.m')
    b.sdk = 'iphoneos'
    b.archs = {
        'armv7',
        'arm64',
    }
    b.include_dirs = {
        'src/lib',
    }
    b.frameworks = {
        'Foundation',
    }
    b.build_dir = 'build'
    b.output = 'libobjcbeagle.dylib'
    b:link(b:compile())

    fs.mkdir(deb.input..'/usr/local/lib')
    os.pexecute('cp '..b.output..' '..deb.input..'/usr/local/lib')

    deb:make_deb()
end

function info()
    deb:print_packageinfo()
end

function clean()
    os.pexecute("rm -rf "..deb.output.." "..deb.input)
end
