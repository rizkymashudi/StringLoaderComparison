//
//  ContentView.swift
//  StringLoaderExample
//
//  Created by Rizky Mashudi on 16/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var displayStrings: [String] = []
    @State private var dbTime: Double = 0
    @State private var nativeTime: Double = 0

    var body: some View {
        VStack {
            Text("Performance Comparison")
                .font(.largeTitle)
                .padding()
            
            Button(action: loadFromDatabase) {
                Text("Load from Database")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            
            Button(action: loadFromNative) {
                Text("Load from Native")
                    .foregroundColor(.green)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 1.0)
            )
            .padding(.horizontal)
            
            Text("Database Load Time: \(dbTime, specifier: "%.2f") seconds")
            Text("Native Load Time: \(nativeTime, specifier: "%.2f") seconds")
            
            List(displayStrings, id: \.self) { string in
                Text(string)
            }
        }
        .onAppear {
            DatabaseManager.shared.insertDummyStrings()
        }
    }
    
    func loadFromDatabase() {
        let startTime = CFAbsoluteTimeGetCurrent()
        displayStrings = DatabaseManager.shared.getAllStrings()
        dbTime = CFAbsoluteTimeGetCurrent() - startTime //TODO: improve the time load velocity calculation
    }
    
    func loadFromNative() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let keys = [
            "welcome_message", "login_prompt", "username_label", "password_label",
            "login_button", "logout_button", "home_tab", "profile_tab", "settings_tab",
            "help_tab", "about_tab", "search_placeholder", "error_message", "success_message",
            "loading_message", "no_results_found", "update_available", "update_now", "later_button",
            "save_button", "cancel_button", "delete_button", "edit_button", "view_button",
            "next_button", "previous_button", "submit_button", "reset_button", "confirm_button",
            "back_button", "menu_button", "notification_title", "notification_body", "message_title",
            "message_body", "alert_title", "alert_body", "dialog_title", "dialog_body", "welcome_back",
            "logout_confirmation", "delete_confirmation", "yes_button", "no_button", "ok_button",
            "retry_button", "skip_button", "exit_button", "continue_button", "close_button", "open_button",
            "new_button", "refresh_button", "download_button", "upload_button", "install_button",
            "uninstall_button", "clear_button", "select_button", "deselect_button", "confirm_password_label",
            "email_label", "phone_label", "address_label", "city_label", "state_label", "zip_code_label",
            "country_label", "date_of_birth_label", "gender_label", "male_option", "female_option",
            "other_option", "language_label", "timezone_label", "currency_label", "notifications_label",
            "privacy_label", "terms_label", "privacy_policy_label", "contact_us_label", "faq_label",
            "feedback_label", "rate_us_label", "share_app_label", "sign_up_button", "forgot_password_button",
            "resend_verification_button", "verify_email_message", "password_reset_message", "password_reset_success",
            "account_created_message", "account_activation_message", "invalid_credentials_message",
            "account_locked_message", "account_disabled_message", "account_not_found_message", "session_expired_message",
            "permission_denied_message", "network_error_message", "server_error_message", "maintenance_message",
            "account_settings_label", "profile_settings_label", "notification_settings_label", "privacy_settings_label",
            "security_settings_label", "language_settings_label", "display_settings_label", "update_profile_button",
            "change_password_button", "current_password_label", "new_password_label", "password_mismatch_message",
            "password_changed_message", "profile_updated_message", "settings_saved_message", "dark_mode_label",
            "light_mode_label", "system_default_label", "theme_label", "font_size_label", "small_option",
            "medium_option", "large_option", "extra_large_option", "apply_button", "discard_changes_button",
            "select_all_button", "deselect_all_button", "bulk_action_label", "export_button", "import_button",
            "backup_button", "restore_button", "sync_button", "help_center_label", "documentation_label",
            "tutorials_label", "community_forum_label", "contact_support_label", "report_issue_label",
            "version_label", "build_label", "release_notes_label", "license_label", "acknowledgements_label",
            "credits_label", "feedback_prompt", "submit_feedback_button", "rate_experience_prompt", "rate_experience_button",
            "update_available_message"
        ]
        var strings = [String]()
        for key in keys {
            strings.append(NSLocalizedString(key, comment: ""))
        }
        
//        for i in 1...150 {
//            strings.append(NSLocalizedString("String\(i)", comment: ""))
//        }
        displayStrings = strings
        nativeTime = CFAbsoluteTimeGetCurrent() - startTime //TODO: improve the time load velocity calculation
    }
}


#Preview {
    ContentView()
}
