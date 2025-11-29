

export type LoginUserType = {
    email: string,
    password: string
}

export type SignupUserType = {
    full_name: string,
    username: string,
    email: string,
    SCC: string,
    password: string,
    confirmPassword?: string
}

export type AuthReturnType = {
    success: boolean,
    message: string,
    token?: string,
    field?: string
}

export type ProfileType = {
    full_name: string,
    username: string,
    email: string,
    SCC: string,
    bio: string | null,
    profile_pic: string | null
}

export type useAuthStoreType = {
    isAuthenticated: boolean,
    loginUser: (data: LoginUserType) => Promise<AuthReturnType>,
    signupUser: (data: SignupUserType) => Promise<AuthReturnType>,
    checkAuth: () => void,
    logout: () => Promise<void>,
    updateProfile: (userId: string, data: ProfileType) => Promise<AuthReturnType>
};