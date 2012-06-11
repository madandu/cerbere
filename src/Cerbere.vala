/*
 * Cerbere.vala
 * This file is part of cerbere, a watchdog for the Pantheon Desktop
 *
 * Copyright (C) 2011-2012 - Allen Lowe
 *
 * Cerbere is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Cerbere is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cerbere; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA  02110-1301  USA
 *
 * Authors: Allen Lowe <allen@elementaryos.org>
 *          ammonkey <am.monkeyd@gmail.com>
 *          Victor Eduardo <victoreduardm@gmail.com>
 */

public class Cerbere : GLib.Application {

    public static SettingsManager settings { get; private set; default = null; }
    private Watchdog watchdog;

    construct {
        application_id = "org.pantheon.cerbere";
        flags = GLib.ApplicationFlags.IS_SERVICE;
    }

    protected override void startup () {
        this.settings = new SettingsManager ();

        // Start watchdog
        this.watchdog = new Watchdog ();

        this.start_processes (this.settings.process_list);

        // Monitor changes
        this.settings.process_list_changed.connect (this.start_processes);

        var main_loop = new MainLoop ();
        main_loop.run ();
    }

    private void start_processes (string[] process_list) {
        foreach (string cmd in process_list) {
            watchdog.add_process_async (cmd);
        }
    }

    public static int main (string[] args) {
        var app = new Cerbere ();
        return app.run (args);
    }
}
