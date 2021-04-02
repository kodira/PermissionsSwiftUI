//
//  File.swift
//  
//
//  Created by Jevon Mao on 3/25/21.
//

import Combine

/**
 The schema storage class that coordinates PermissionsSwiftUI's internal functions
 */
public class PermissionSchemaStore: ObservableObject {

    //MARK: Filtered permission arrays
    var undeterminedPermissions: [PermissionType] {
        FilterPermissions.filterForShouldAskPermission(for: permissions)
    }
    var interactedPermissions: [PermissionType] {
        //Filter for permissions that are not interacted
        permissions.filter{permissionComponentsStore.getPermissionComponent(for: $0, modify: {_ in}).interacted}
    }
    var successfulPermissions: [JMResult]?
    var erroneousPermissions: [JMResult]?
    
    //MARK: Controls dismiss restriction
    var shouldStayInPresentation: Bool {
        if configStore.restrictDismissal {
            //Empty means all permissions interacted, so should no longer stay in presentation
            return !(interactedPermissions.count == permissions.count)
        }
        return false
    }
    //MARK: Initialized configuration properties
    var configStore: ConfigStore
    @Published var permissions: [PermissionType]
    var permissionViewStyle: PermissionViewStyle
    @usableFromInline var permissionComponentsStore: PermissionComponentsStore
    init(configStore: ConfigStore, permissions: [PermissionType], permissionComponentsStore: PermissionComponentsStore, permissionViewStyle: PermissionViewStyle) {
        self.configStore = configStore
        self.permissions = permissions
        self.permissionComponentsStore = permissionComponentsStore
        self.permissionViewStyle = permissionViewStyle
    }
    
}

@usableFromInline enum PermissionViewStyle {
    case alert, modal
}
