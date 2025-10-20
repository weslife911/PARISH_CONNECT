

export type LoginUser = {
    email: string,
    password: string
}

export type SignupUser = {
    full_name: string,
    username: string,
    email: string,
    SCC: string,
    password: string
}

export type AuthReturnType = {
    success: boolean,
    message: string,
    token?: string,
    field?: string
}

export type useAuthStoreType = {
    isAuthenticated: boolean,
    loginUser: (data: LoginUser) => Promise<AuthReturnType>,
    signupUser: (data: SignupUser) => Promise<AuthReturnType>,
    checkAuth: () => void,
    logout: () => Promise<void>
};