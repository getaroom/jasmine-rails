/*globals jasmine,blanket,Exception*/
(function() {

    if (typeof jasmine === 'undefined') {
        throw new Exception('jasmine library does not exist in global namespace!');
    }

    function elapsed(startTime, endTime) {
        return (endTime - startTime)/1000;
    }

    function ISODateString(d) {
        function pad(n) { return n < 10 ? '0'+n : n; }

        return d.getFullYear() + '-' +
            pad(d.getMonth()+1) + '-' +
            pad(d.getDate()) + 'T' +
            pad(d.getHours()) + ':' +
            pad(d.getMinutes()) + ':' +
            pad(d.getSeconds());
    }

    function trim(str) {
        return str.replace(/^\s+/, '' ).replace(/\s+$/, '' );
    }

    function escapeInvalidXmlChars(str) {
        return str.replace(/\&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/\>/g, '&gt;')
            .replace(/\'/g, '&quot;')
            .replace(/\'/g, '&apos;');
    }

    var env = jasmine.getEnv()
    /**
     * based on https://raw.github.com/larrymyers/jasmine-reporters/master/src/jasmine.junit_reporter.js
     */
    , BlanketReporter = function() {
        blanket.setupCoverage();
    };
    BlanketReporter.finished_at = null; // will be updated after all files have been written


    BlanketReporter.prototype.specStarted = function(spec) {
        blanket.onTestStart();
    };

    BlanketReporter.prototype.specDone = function(result) {
        var passed = result.status === 'passed' ? 1 : 0;
        blanket.onTestDone(1,passed);
    };

    BlanketReporter.prototype.jasmineDone = function() {
        blanket.onTestsDone();
    };

    BlanketReporter.prototype.log = function(str) {
        var console = jasmine.getGlobal().console;

        if (console && console.log) {
            console.log(str);
        }
    };

    // export public
    jasmine.BlanketReporter = BlanketReporter;
    window.BlanketReporter = new jasmine.BlanketReporter();

    env.addReporter(window.BlanketReporter);


    blanket.options('reporter', function (coverageData, options) {
        blanket.defaultReporter(coverageData,options);
        var filename
        , report = ''
        , data
        , processReport = function (filename, data) {
            var rtn = '';
            filename = getFullFilePath(filename);
            rtn += 'SF:' + filename + '\n';

            data.source.forEach(function(line, num) {
                // increase the line number, as JS arrays are zero-based
                num++;

                if (data[num] !== undefined) {
                    rtn += 'DA:' + num + ',' + data[num] + '\n';
                }
            });
            rtn += 'end_of_record\n';

            return rtn;
        }
        , getFullFilePath = function (filename) {
            if (typeof window.callPhantom === 'function') {
                return window.callPhantom({
                    event: 'getFilePath'
                    , filename: filename
                });
            } else {
                return filename;
            }
        };


        for (filename in coverageData.files) {
            if (coverageData.files.hasOwnProperty(filename)) {
                data = coverageData.files[filename];
                report += processReport(filename,data);
            }
        }

        window.lcovReport = report;

        if (typeof window.callPhantom === 'function') {
            window.callPhantom({
                event: 'writeFile'
                , text: report
                , filename: 'tmp/jscoverage.info'
            });
        }
    });
})();
