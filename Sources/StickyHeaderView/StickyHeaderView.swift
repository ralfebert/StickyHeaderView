import SwiftUI

public struct StickyHeaderView<Header: View, Gradient: View, Content: View>: View {
    @ViewBuilder let header: () -> Header
    @ViewBuilder let gradient: () -> Gradient
    @ViewBuilder let content: () -> Content

    public init(header: @escaping () -> Header, gradient: @escaping () -> Gradient, content: @escaping () -> Content) {
        self.header = header
        self.gradient = gradient
        self.content = content
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                header()
                    .frame(maxWidth: .infinity)
                    .background {
                        gradient()
                            .offset(y: -500)
                            .padding(.bottom, -500)
                    }

                content()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#if DEBUG
    struct StickyHeaderExampleView: View {
        var body: some View {
            StickyHeaderView(
                header: {
                    Image(systemName: "lasso.badge.sparkles")
                        .font(.system(size: 120))
                        .padding()
                        .foregroundStyle(.white)
                },
                gradient: {
                    RadialGradient(gradient: Gradient(stops: [.init(color: .red, location: 0), .init(color: .yellow, location: 1)]), center: .bottom, startRadius: 0, endRadius: 300)
                },
                content: {
                    VStack {
                        ForEach(1 ... 30, id: \.self) { idx in
                            Text("Hello, world! \(idx)")
                        }
                    }
                }
            )
            .navigationBarTitle("Example", displayMode: .inline)
        }
    }

    #Preview("In a sheet") {
        Color.yellow
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    StickyHeaderExampleView()
                }
            }
    }

    #Preview("Standalone") {
        NavigationStack {
            StickyHeaderExampleView()
        }
    }
#endif
